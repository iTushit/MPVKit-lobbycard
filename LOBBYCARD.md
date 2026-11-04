# MPVKit for Lobbycard

A build of [MPVKit](https://github.com/mpvkit/MPVKit) 1.0.0 (mpv 0.41.0, FFmpeg 8.1.2) for the
Lobbycard app, with these changes to MPVKit's build script
(`Sources/BuildScripts/XCFrameworkBuild/main.swift`, marked "Lobbycard"):

1. **LGPL 2.1 only.** FFmpeg uses Apple's TLS (Secure Transport, `--enable-securetransport`)
   instead of GnuTLS, so GnuTLS, GMP and Nettle (LGPLv3) are neither built nor linked, and FFmpeg
   is configured without `--enable-version3`. Its configuration reads "LGPL version 2.1 or later".
2. **No DTS or TrueHD decoders** (`--disable-decoder=dca,truehd,mlp`).
3. FFmpeg's check for `SecItemImport` uses its header, so Mac Catalyst builds with Secure
   Transport (loading certificate files is left out there).

The other libraries (libass, libplacebo, MoltenVK, dav1d, …) are MPVKit's own prebuilt ones,
unchanged. The built frameworks and the complete source code of every library they contain are
attached to this repository's releases.

## Dynamic frameworks (from 1.0.0-lobbycard.2)

The released frameworks are **dynamic**: the app loads mpv, FFmpeg, libass and the rest as
separate libraries inside its bundle, so anyone can replace them with their own builds without
the app's object files (LGPL 2.1 §6(b)). `make-dynamic.py` makes them from the static build:
each library is linked whole into its own dynamic library, against the others it uses.

FFmpeg's seven libraries call each other's internal functions, and shaderc (used by FFmpeg and
libplacebo) exports none, so FFmpeg, libplacebo and shaderc are one dynamic library, in the
`Libavutil` framework; the `Libavcodec`, `Libavformat`, `Libavfilter`, `Libavdevice`,
`Libswresample`, `Libswscale`, `Libplacebo` and `Libshaderc_combined` frameworks keep their
headers and re-export it. Platforms: iOS, iOS Simulator, Mac Catalyst, tvOS (arm64), tvOS
Simulator. Libluajit (macOS only) is left out.

## Building

```sh
brew install meson ninja nasm cmake automake
make build platform=ios,isimulator,tvos,tvsimulator,maccatalyst
```

The frameworks land in `dist/release/`. Then:

```sh
python3 lobbycard-release.py --local                     # static, unzipped: dist/lobbycard/local
python3 make-dynamic.py dist/lobbycard/local dist/lobbycard/dynamic
python3 lobbycard-release.py --dynamic <tag> <sources.tar>
``` Licences: MPVKit's scripts LGPL-3.0 (see `LICENSE`); mpv
and FFmpeg LGPL-2.1-or-later as built here; the other libraries under their own licences.
