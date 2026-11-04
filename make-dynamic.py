#!/usr/bin/env python3
"""
Turns this build's static xcframeworks into dynamic ones, with the same names, so the app loads
mpv, FFmpeg and the rest as separate libraries it doesn't contain: the LGPL's "suitable shared
library mechanism" (v2.1 §6(b)), so nobody needs the app's object files to relink it.

  python3 make-dynamic.py <static xcframeworks folder> <output folder>

Each library is linked whole (-all_load) into its own dynamic library, against the dynamic
versions of the libraries it uses (found from their symbols) and Apple's system frameworks, in
dependency order, for each platform and architecture; then packaged as a framework per platform
(Mac Catalyst: the versioned Mac layout) and an xcframework.
"""
import glob, os, plistlib, re, shutil, subprocess, sys, tempfile

src, out = os.path.abspath(sys.argv[1]), os.path.abspath(sys.argv[2])
MIN = "15.0"

# Platform slices built: output name → (static slice folder, target OS, SDK, framework layout).
SLICES = {
    "ios-arm64": ("ios-arm64", "ios", "iphoneos", "shallow"),
    "ios-arm64_x86_64-simulator": ("ios-arm64_x86_64-simulator", "ios-simulator", "iphonesimulator", "shallow"),
    "ios-arm64_x86_64-maccatalyst": ("ios-arm64_x86_64-maccatalyst", "ios-macabi", "macosx", "versioned"),
    "tvos-arm64": ("tvos-arm64_arm64e", "tvos", "appletvos", "shallow"),  # arm64e left out
    "tvos-arm64_x86_64-simulator": ("tvos-arm64_x86_64-simulator", "tvos-simulator", "appletvsimulator", "shallow"),
}
SYSTEM = ["Foundation", "CoreFoundation", "CoreVideo", "CoreMedia", "VideoToolbox", "AudioToolbox", "AVFoundation",
          "Security", "Metal", "QuartzCore", "IOSurface", "CoreGraphics", "CoreText", "UIKit", "CoreAudio"]
LIBS = ["-lc++", "-lz", "-lbz2", "-liconv", "-lxml2", "-lresolv", "-lexpat"]


def run(*args, **kw):
    r = subprocess.run(args, capture_output=True, text=True, **kw)
    if r.returncode:
        raise SystemExit(f"failed: {' '.join(args)[:300]}\n{r.stderr[-3000:]}")
    return r.stdout


def static_binary(xcf, name, slice_folder):
    """The static archive of a slice."""
    for d in [os.path.join(xcf, slice_folder)]:
        for c in glob.glob(f"{d}/{name}.framework/Versions/A/{name}") + glob.glob(f"{d}/{name}.framework/{name}") + glob.glob(f"{d}/*.a"):
            if os.path.isfile(c):
                return d, c
    return None, None


def thin_copy(binary, arch, dest):
    """One architecture of a binary, as a plain (not fat) file."""
    if "Architectures in the fat file" in run("lipo", "-info", binary):
        run("lipo", binary, "-thin", arch, "-output", dest)
    else:
        shutil.copy(binary, dest)


def archs(binary):
    return run("lipo", "-archs", binary).split()


# The libraries and their static archives (each slice).
names = sorted(os.path.basename(x)[:-12] for x in glob.glob(f"{src}/*.xcframework"))
names = [n for n in names if n != "Libluajit"]  # macOS-only (mpv's Lua on macOS); not built here

# Dependencies from symbols (iOS device slice): which library defines what another one needs.
defined, needed = {}, {}
for n in names:
    _, b = static_binary(f"{src}/{n}.xcframework", n, "ios-arm64")
    with tempfile.TemporaryDirectory() as t:
        thin = os.path.join(t, "a")
        thin_copy(b, "arm64", thin)
        # Only what it exports (not hidden "private external" symbols, such as shaderc's copy of libc++).
        listing = run("nm", "-m", thin)
        defined[n] = {l.split()[-1] for l in listing.splitlines()
                      if " external " in l and "(undefined)" not in l and "private external" not in l}
        # libc++ template copies say nothing about dependencies (they come from -lc++).
        defined[n] = {x for x in defined[n] if "St3__" not in x and not re.match(r"__ZT[ISV]St", x)}
        needed[n] = set(run("nm", "-uj", thin).split()) - defined[n]
# FFmpeg's libraries call each other's internal (hidden) functions, and shaderc (used by FFmpeg
# and libplacebo) exports nothing, so these can only be one dynamic library: all of them are
# linked into Libavutil; the other frameworks keep their headers and re-export it.
STUBS = ["Libswresample", "Libswscale", "Libavcodec", "Libavformat", "Libavfilter", "Libavdevice",
         "Libplacebo", "Libshaderc_combined"]
for m in STUBS:
    defined["Libavutil"] |= defined[m]
    needed["Libavutil"] |= needed[m]
needed["Libavutil"] -= defined["Libavutil"]
def resolved(n):
    return set() if n in STUBS else {"Libavutil" if m in STUBS else m for m in names if m != n and m not in STUBS and needed[n] & defined[m]} | ({"Libavutil"} if n != "Libavutil" and any(needed[n] & defined[m] for m in STUBS) else set())
deps = {n: sorted(resolved(n) - {n}) for n in names}
for m in STUBS:
    deps[m] = ["Libavutil"]
order, seen = [], set()
def visit(n):
    if n in seen: return
    seen.add(n)
    for d in deps[n]: visit(d)
    order.append(n)
for n in names: visit(n)
print("order:", " → ".join(order))

shutil.rmtree(out, ignore_errors=True)
os.makedirs(out)
for slice_name, (folder, os_name, sdk, layout) in SLICES.items():
    sdk_path = run("xcrun", "--sdk", sdk, "--show-sdk-path").strip()
    built = os.path.join(out, "slices", slice_name)
    os.makedirs(built, exist_ok=True)
    system = SYSTEM + (["IOKit"] if layout == "versioned" else ["OpenGLES"])
    for n in order:
        sdir, sbin = static_binary(f"{src}/{n}.xcframework", n, folder)
        if not sbin:
            raise SystemExit(f"{n}: no {slice_name} slice")
        wanted = [a for a in ["arm64", "x86_64"] if a in archs(sbin) and (a == "arm64" or "simulator" in slice_name or "maccatalyst" in slice_name)]
        fw = os.path.join(built, f"{n}.framework")
        shutil.rmtree(fw, ignore_errors=True)
        rel = f"Versions/A/{n}" if layout == "versioned" else n
        bin_dir = os.path.join(fw, "Versions", "A") if layout == "versioned" else fw
        os.makedirs(bin_dir)
        thin_outs = []
        with tempfile.TemporaryDirectory() as t:
            for arch in wanted:
                thin = os.path.join(t, f"{arch}.a")
                thin_copy(sbin, arch, thin)
                target = f"{arch}-apple-{os_name.split('-')[0]}{MIN}" + ("-simulator" if "simulator" in os_name else "-macabi" if "macabi" in os_name else "")
                dylib = os.path.join(t, f"{arch}.dylib")
                if n in STUBS:
                    empty = os.path.join(t, "empty.c")
                    open(empty, "w").write("")
                    run("xcrun", "clang", "-dynamiclib", "-target", target, "-isysroot", sdk_path, empty,
                        "-install_name", f"@rpath/{n}.framework/{rel}", "-F", built,
                        "-Wl,-reexport_framework,Libavutil", "-o", dylib)
                    thin_outs.append(dylib)
                    continue
                inputs = [thin]
                if n == "Libavutil":
                    for m in STUBS:
                        _, mbin = static_binary(f"{src}/{m}.xcframework", m, folder)
                        mthin = os.path.join(t, f"{m}-{arch}.a")
                        thin_copy(mbin, arch, mthin)
                        # Files FFmpeg compiles into several of its libraries (#include of the same
                        # source): one copy each.
                        for obj in {"Libavcodec": ["vulkan.o"], "Libavfilter": ["vulkan.o"],
                                    "Libswscale": ["vulkan.o", "vulkan_shaderc.o"]}.get(m, []):
                            run("ar", "-d", mthin, obj)
                        inputs.append(mthin)
                cmd = ["xcrun", "clang", "-dynamiclib", "-target", target, "-isysroot", sdk_path,
                       "-Wl,-all_load", *inputs, "-install_name", f"@rpath/{n}.framework/{rel}",
                       "-Wl,-dead_strip_dylibs", "-F", built, "-o", dylib]
                if layout == "versioned":
                    cmd += ["-iframework", f"{sdk_path}/System/iOSSupport/System/Library/Frameworks",
                            "-F", f"{sdk_path}/System/iOSSupport/System/Library/Frameworks"]
                for d in deps[n]:
                    cmd += ["-framework", d]
                for f in system:
                    cmd += ["-framework", f]
                cmd += LIBS
                run(*cmd)
                thin_outs.append(dylib)
            run("lipo", "-create", *thin_outs, "-output", os.path.join(bin_dir, n))
        # Headers and modules from the static framework; an Info.plist for a dynamic one.
        static_fw = os.path.join(sdir, f"{n}.framework")
        for part in ["Headers", "Modules"]:
            for p in [os.path.join(static_fw, "Versions", "A", part), os.path.join(static_fw, part)]:
                if os.path.isdir(p) and not os.path.islink(p):
                    shutil.copytree(p, os.path.join(bin_dir, part), dirs_exist_ok=True)
                    break
        info = {"CFBundleExecutable": n, "CFBundleIdentifier": f"app.lobbycard.mpvkit.{n.lower().replace('_', '-')}", "CFBundleName": n,
                "CFBundlePackageType": "FMWK", "CFBundleShortVersionString": "1.0.0", "CFBundleVersion": "2",
                "CFBundleInfoDictionaryVersion": "6.0", "CFBundleDevelopmentRegion": "en"}
        if layout == "versioned":
            res = os.path.join(bin_dir, "Resources")
            os.makedirs(res)
            info["LSMinimumSystemVersion"] = "12.0"
            plistlib.dump(info, open(os.path.join(res, "Info.plist"), "wb"))
            os.symlink("A", os.path.join(fw, "Versions", "Current"))
            for link in [n, "Resources", "Headers", "Modules"]:
                if link == n or os.path.exists(os.path.join(bin_dir, link)):
                    os.symlink(f"Versions/Current/{link}", os.path.join(fw, link))
        else:
            info["MinimumOSVersion"] = MIN
            plistlib.dump(info, open(os.path.join(fw, "Info.plist"), "wb"))
        print(f"  {slice_name:32s} {n}")

# One xcframework per library from its five slices.
for n in order:
    args = []
    for slice_name in SLICES:
        args += ["-framework", os.path.join(out, "slices", slice_name, f"{n}.framework")]
    run("xcodebuild", "-create-xcframework", *args, "-output", os.path.join(out, f"{n}.xcframework"))
shutil.rmtree(os.path.join(out, "slices"))
print("dynamic xcframeworks in", out)
