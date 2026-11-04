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
                .target(name: "Libluajit", condition: .when(platforms: [.macOS])),
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
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libunibreak.xcframework.zip",
            checksum: "940d9833cf4477d0a260d9f2b4066125bc0ff7bbc111ac3c90e774765b77a559"
        ),

        .binaryTarget(
            name: "Libfreetype",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libfreetype.xcframework.zip",
            checksum: "496ca62488530e14b1e4624d20ee2b237c0bd675cd70c19da578a5768302d02d"
        ),

        .binaryTarget(
            name: "Libfribidi",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libfribidi.xcframework.zip",
            checksum: "bc15e097b892f2f90424e4a27ba287070cc2f98a74a4da10e6d2481d15cf5ff9"
        ),

        .binaryTarget(
            name: "Libharfbuzz",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libharfbuzz.xcframework.zip",
            checksum: "aa8e0b9ca0387dac74e3e93c86e34d11982bb013b28022d0e6966a8427a35b2e"
        ),

        .binaryTarget(
            name: "Libass",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libass.xcframework.zip",
            checksum: "3f4c576d2818ceb4544aa2a20e1f55846511c5e706fd19adc3ea9fd842270498"
        ),


        .binaryTarget(
            name: "Libbluray",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libbluray.xcframework.zip",
            checksum: "bc037d34e2b0b5ab7f202fb371f5fb298136cc66fdf406c2172185d06f53f18d"
        ),

        .binaryTarget(
            name: "Libuavs3d",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libuavs3d.xcframework.zip",
            checksum: "bd5256081486d16c51c868d755bf70266c424b54c895269580de44ec6707f789"
        ),

        .binaryTarget(
            name: "Libdovi",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libdovi.xcframework.zip",
            checksum: "e693e239808350868e79c5448ef9f02e2716bc822dd8632a41a368a1eae5ca7d"
        ),

        .binaryTarget(
            name: "MoltenVK",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/MoltenVK.xcframework.zip",
            checksum: "aee189c54ad7c62bf734a3dc51eb4cfad5685d1d63b0ec519ecd1b437c332418"
        ),

        .binaryTarget(
            name: "Libshaderc_combined",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libshaderc_combined.xcframework.zip",
            checksum: "758047b615708575b580eb960a2d083f760a29dc462d6eaa360416c946ce433b"
        ),

        .binaryTarget(
            name: "lcms2",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/lcms2.xcframework.zip",
            checksum: "dc0dce0606f6ab6841a8ec5a6bd4448e2f3ef00661a050460f806c9393dc6982"
        ),

        .binaryTarget(
            name: "Libplacebo",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libplacebo.xcframework.zip",
            checksum: "2fa3d54cb81f302d6f11c7b2f509af30944381c3b11ee9d35096eb4637a6e2dd"
        ),

        .binaryTarget(
            name: "Libdav1d",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libdav1d.xcframework.zip",
            checksum: "d1a32ae6a1f0193e9f05c44c9176844af7f6d2a58cb33843f6f1b8dfd9224083"
        ),

        .binaryTarget(
            name: "Libavcodec",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libavcodec.xcframework.zip",
            checksum: "87c30d7664747e00529d915cfcfd6b8c7ea28aa4a0ff20098f3e42b6f14963ac"
        ),
        .binaryTarget(
            name: "Libavdevice",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libavdevice.xcframework.zip",
            checksum: "60c0cad4c20f8fd615e345dad96606441c9c1cb5bb82a20d0f4e6cae475c59ff"
        ),
        .binaryTarget(
            name: "Libavformat",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libavformat.xcframework.zip",
            checksum: "c890e7cf5eb1975c68a0e09c5d02e3fb06e404b1b91dd6a0fd6c99dff57affa9"
        ),
        .binaryTarget(
            name: "Libavfilter",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libavfilter.xcframework.zip",
            checksum: "14eabe6d23dde461f8d8464bdc77cb5e388c64927bdf3cae5234f98383b395e6"
        ),
        .binaryTarget(
            name: "Libavutil",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libavutil.xcframework.zip",
            checksum: "5a45713804ee02afb5a55f651b106a61976c6ecfb5263ff5dcf76bfc3d73b178"
        ),
        .binaryTarget(
            name: "Libswresample",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libswresample.xcframework.zip",
            checksum: "0d8be3b8c74c94b02d57fafafc78176d14ed89b1ae63d84d6d3f1d77e792e585"
        ),
        .binaryTarget(
            name: "Libswscale",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libswscale.xcframework.zip",
            checksum: "6bd0917847bf79112fd4c3632108128af2a194cfffb47e647924ecc5867745ae"
        ),

        .binaryTarget(
            name: "Libuchardet",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libuchardet.xcframework.zip",
            checksum: "ea4f548a230a755e059144657cc9e2ff563c1cdeae03974c38f8b6e1a40303fb"
        ),

        .binaryTarget(
            name: "Libluajit",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libluajit.xcframework.zip",
            checksum: "3a171ef1627fb88260893dc452f989bd93dd8510814771ba3aff7753470d3f3e"
        ),

        .binaryTarget(
            name: "Libmpv",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.1/Libmpv.xcframework.zip",
            checksum: "2562ad906c5c20116a639b9c37337cf50f8e26f2608097923d16c30295760c4d"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
