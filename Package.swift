// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "MPVKit",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .visionOS(.v1)],
    products: [
        .library(
            name: "MPVKit",
            targets: ["_MPVKit"]
        ),
    ],
    targets: [
        .target(
            name: "_MPVKit",
            dependencies: [
                "Libmpv", "_FFmpeg", "Libuchardet", "Libbluray",
            ],
            path: "Sources/_MPVKit",
            linkerSettings: [
                .linkedFramework("AVFoundation"),
                .linkedFramework("CoreAudio"),
            ]
        ),
        .target(
            name: "_FFmpeg",
            dependencies: [
                "Libavcodec", "Libavdevice", "Libavfilter", "Libavformat", "Libavutil", "Libswresample", "Libswscale",
                "Libass", "Libfreetype", "Libfribidi", "Libharfbuzz",
                "MoltenVK", "Libshaderc_combined", "lcms2", "Libplacebo", "Libdovi", "Libunibreak",
                "Libdav1d", "Libuavs3d"
            ],
            path: "Sources/_FFmpeg",
            linkerSettings: [
                .linkedFramework("AudioToolbox"),
                .linkedFramework("CoreVideo"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("CoreMedia"),
                .linkedFramework("Metal"),
                .linkedFramework("VideoToolbox"),
                .linkedLibrary("bz2"),
                .linkedLibrary("iconv"),
                .linkedLibrary("expat"),
                .linkedLibrary("resolv"),
                .linkedLibrary("xml2"),
                .linkedLibrary("z"),
                .linkedLibrary("c++"),
            ]
        ),

        //AUTO_GENERATE_TARGETS_BEGIN//





        .binaryTarget(
            name: "Libunibreak",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libunibreak.xcframework.zip",
            checksum: "a4a8567e5454a28c539de3e6bc5018fd499516ae5be3152d56857b1e47253c16"
        ),

        .binaryTarget(
            name: "Libfreetype",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libfreetype.xcframework.zip",
            checksum: "caa886f4027c778e0b6ca7ead5b83e6fda8451d189afb3eb0b68656002c52145"
        ),

        .binaryTarget(
            name: "Libfribidi",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libfribidi.xcframework.zip",
            checksum: "e13f0eebbfa4ca04fe3de639136a9ee7d35f5d7fe698f22aa721609848e1b18a"
        ),

        .binaryTarget(
            name: "Libharfbuzz",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libharfbuzz.xcframework.zip",
            checksum: "84734a3e729ed94daf4f82f98cd4895a80a55132458984bbd5edc74a56d9bbbb"
        ),

        .binaryTarget(
            name: "Libass",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libass.xcframework.zip",
            checksum: "67c080ab75f500747ad115ba616a161658cd87e3c81a836a44f887d2835e12ab"
        ),


        .binaryTarget(
            name: "Libbluray",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libbluray.xcframework.zip",
            checksum: "b29f2fe73d2657cc6d5a8036f5d8551a2555b3a915cf61a6ef55f161572b28df"
        ),

        .binaryTarget(
            name: "Libuavs3d",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libuavs3d.xcframework.zip",
            checksum: "70c67e8887fa98f447b2d3729109fd3e15effd31f7bd612de02f6bff7c8cde7a"
        ),

        .binaryTarget(
            name: "Libdovi",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libdovi.xcframework.zip",
            checksum: "2ac957f287ef0a613197891623556c7cf1f46a5a88e6341e823275c68a990811"
        ),

        .binaryTarget(
            name: "MoltenVK",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/MoltenVK.xcframework.zip",
            checksum: "5ac368cd902f45d09c85e933e9c2c606caf6fa9d4c51026e6aad236e535cb8ea"
        ),

        .binaryTarget(
            name: "Libshaderc_combined",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libshaderc_combined.xcframework.zip",
            checksum: "1c4cc1491ad04a483e2e7a99c9bbbb803c512757daf5ed7782f5a8180b634cc1"
        ),

        .binaryTarget(
            name: "lcms2",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/lcms2.xcframework.zip",
            checksum: "3903348a00825a9d6b1ff6129333888c860d1d744fa1dd605f0288223d733a88"
        ),

        .binaryTarget(
            name: "Libplacebo",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libplacebo.xcframework.zip",
            checksum: "6071585f7178af776c51d0460f220c49a8c427159a462a40a008f07e45c0dbae"
        ),

        .binaryTarget(
            name: "Libdav1d",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libdav1d.xcframework.zip",
            checksum: "2c0878d87a82a8df8381e53aa7db8fae5c06140c054fa66bfb702c6f3f7df625"
        ),

        .binaryTarget(
            name: "Libavcodec",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libavcodec.xcframework.zip",
            checksum: "e6f715771e25821b7bdc814574af439eba59cd4e6fdc02316cc64447b016db60"
        ),
        .binaryTarget(
            name: "Libavdevice",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libavdevice.xcframework.zip",
            checksum: "272b3b15c402e0ec9f8abb2706217c2ee1b5e07b836ccd7bb5126fb24ed52257"
        ),
        .binaryTarget(
            name: "Libavformat",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libavformat.xcframework.zip",
            checksum: "59ee5a7da12cac53365e16e8d73cf124441eb9b0f62defbb0bfa0dab59208555"
        ),
        .binaryTarget(
            name: "Libavfilter",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libavfilter.xcframework.zip",
            checksum: "641e937284fa41224e4ddef1ef45b79e9e4c5262acaa4c6f2b6a37f18540025d"
        ),
        .binaryTarget(
            name: "Libavutil",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libavutil.xcframework.zip",
            checksum: "a2a7236c910465abc31698c4911a3a7821583dd2df9b00cc2467502f9eb9091e"
        ),
        .binaryTarget(
            name: "Libswresample",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libswresample.xcframework.zip",
            checksum: "51b1df087cd25128775af79160b47c4e013705804539e0e96a4acfd798a3661d"
        ),
        .binaryTarget(
            name: "Libswscale",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libswscale.xcframework.zip",
            checksum: "85ed121ac604b0874db793ff5a1e8ca6a8f901eb0d86886dd8288f5f2fae8475"
        ),

        .binaryTarget(
            name: "Libuchardet",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libuchardet.xcframework.zip",
            checksum: "ece39e5a4632762ab4118dc04259eedd1deb50a8de32f3e30a64e37afb11946a"
        ),


        .binaryTarget(
            name: "Libmpv",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.2/Libmpv.xcframework.zip",
            checksum: "3d56be677d57c1e4efbd2c0467e10d157156d29050ba84ee40397aa7b549d684"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
