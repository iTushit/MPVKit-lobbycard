#!/usr/bin/env python3
"""
Makes a Lobbycard release of this MPVKit build:

  python3 lobbycard-release.py <tag> [sources.tar]
  python3 lobbycard-release.py --local      (dist/lobbycard/local: a package of the frameworks on this
                                             Mac, for testing the app against them before a release)

1. The frameworks built here (dist/release: mpv and FFmpeg's libraries) and copies of MPVKit's
   other prebuilt libraries (downloaded from MPVKit's releases, checksums verified), all in
   dist/lobbycard/<tag>/, so this repository's release holds everything it needs.
2. Package.swift: only the LGPL product, without GnuTLS/GMP/Nettle/hogweed and the GPL variant,
   every framework downloaded from this repository's release <tag>.
3. With `gh` signed in: creates the release <tag> with all of it, plus the source archive if given.
"""
import hashlib, os, re, subprocess, sys, urllib.request

REPO = "iTushit/MPVKit-lobbycard"
BUILT = ["Libmpv", "Libavcodec", "Libavdevice", "Libavfilter", "Libavformat", "Libavutil", "Libswresample", "Libswscale"]
# GnuTLS and what it needs (LGPLv3), the GPL-only SMB library, and OpenSSL (FFmpeg uses Apple's TLS).
DROPPED = ["gmp", "nettle", "hogweed", "gnutls", "Libsmbclient", "Libssl", "Libcrypto"]

local = sys.argv[1] == "--local"
tag = "local" if local else sys.argv[1]
sources = sys.argv[2] if len(sys.argv) > 2 and not local else None
here = os.path.dirname(os.path.abspath(__file__))
out = os.path.join(here, "dist", "lobbycard", tag)
os.makedirs(out, exist_ok=True)
package = open(os.path.join(here, "Package.swift")).read()


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


# The package without the GPL variant and the LGPLv3 libraries.
package = re.sub(r'\n        \.library\(\n            name: "MPVKit-GPL",.*?\n        \),', "", package, flags=re.S)
for target in ["_MPVKit-GPL", "_FFmpeg-GPL"]:
    package = re.sub(r'\n        \.target\(\n            name: "%s",.*?\n        \),' % re.escape(target), "", package, flags=re.S)
package = re.sub(r'\n        \.binaryTarget\(\n            name: "[^"]+-GPL",.*?\n        \),', "", package, flags=re.S)
for name in DROPPED:
    package = re.sub(r'\n        \.binaryTarget\(\n            name: "%s",.*?\n        \),' % re.escape(name), "", package, flags=re.S)
package = re.sub(r'\n                "gmp", "nettle", "hogweed", "gnutls", ', '\n                ', package)
package = package.replace('"Libssl", "Libcrypto", ', '')
assert "gnutls" not in package and "-GPL" not in package and "Libssl" not in package, "leftovers in Package.swift"

assets = []
def binary(match):
    name, url, checksum = match.group(1), match.group(2), match.group(3)
    file = os.path.join(out, f"{name}.xcframework.zip")
    if name in BUILT:
        built = os.path.join(here, "dist", "release", f"{name}.xcframework.zip")
        subprocess.run(["cp", built, file], check=True)
        checksum = sha256(file)
    else:
        if not os.path.exists(file):
            print(f"· {name} (MPVKit's prebuilt)")
            urllib.request.urlretrieve(url, file)
        assert sha256(file) == checksum, f"checksum mismatch: {name}"
    assets.append(file)
    if local:
        subprocess.run(["unzip", "-qo", file, "-d", out], check=True)
        return f'.binaryTarget(\n            name: "{name}",\n            path: "{name}.xcframework"'
    new_url = f"https://github.com/{REPO}/releases/download/{tag}/{name}.xcframework.zip"
    return f'.binaryTarget(\n            name: "{name}",\n            url: "{new_url}",\n            checksum: "{checksum}"'

package = re.sub(r'\.binaryTarget\(\n            name: "([^"]+)",\n            url: "([^"]+)",\n            checksum: "([0-9a-f]+)"', binary, package)
if local:
    # A package of its own: Package.swift, the dummy sources, the unzipped frameworks.
    subprocess.run(["rsync", "-a", "--delete", os.path.join(here, "Sources", "_MPVKit"), os.path.join(here, "Sources", "_FFmpeg"),
                    os.path.join(out, "Sources") + "/"], check=True)
    open(os.path.join(out, "Package.swift"), "w").write(package)
    print("local package:", out)
    sys.exit(0)
open(os.path.join(here, "Package.swift"), "w").write(package)
print(f"Package.swift: {len(assets)} frameworks from release {tag}")

if sources:
    assets.append(sources)
# The tag must point at the commit with this Package.swift: commit and push it first.
subprocess.run(["git", "-C", here, "add", "Package.swift"], check=True)
subprocess.run(["git", "-C", here, "commit", "-q", "-m", f"Package.swift for release {tag}"], check=False)
subprocess.run(["git", "-C", here, "push", "-q", "lobbycard", "HEAD:main"], check=True)
head = subprocess.run(["git", "-C", here, "rev-parse", "HEAD"], check=True, capture_output=True, text=True).stdout.strip()
notes = open(os.path.join(here, "LOBBYCARD.md")).read()
subprocess.run(["gh", "release", "create", tag, "--repo", REPO, "--target", head, "--title", f"MPVKit for Lobbycard {tag}",
                "--notes", notes, *assets], check=True)
print("released", tag)
