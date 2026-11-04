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
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libunibreak.xcframework.zip",
            checksum: "39d19b25289ffce85421868190d981188f8cce9c5f4c3dabc47df02140db0e49"
        ),

        .binaryTarget(
            name: "Libfreetype",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libfreetype.xcframework.zip",
            checksum: "6d92e7ef15ba6418990ab2646d86bc68de5d814c87056606ffd0560bc5d23a1b"
        ),

        .binaryTarget(
            name: "Libfribidi",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libfribidi.xcframework.zip",
            checksum: "353904000245c1ba78470f0dfa24bbf6cf3dd5cfda3cf95cabf0c7ba5da2c9cc"
        ),

        .binaryTarget(
            name: "Libharfbuzz",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libharfbuzz.xcframework.zip",
            checksum: "e097fa4ad11817c4132e830c13a3f54d23632c572e0f482d5ab4a4c0182bab01"
        ),

        .binaryTarget(
            name: "Libass",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libass.xcframework.zip",
            checksum: "ebff07bf9f80fb31c2bfa6d9a04bdd92a3d6f3044038bf88cbb2944470a1db6f"
        ),


        .binaryTarget(
            name: "Libbluray",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libbluray.xcframework.zip",
            checksum: "d88f31ca5a8be4476a48a21fd7ae96b9bd68c4fdb0a4b0ee1ffda198599e72ad"
        ),

        .binaryTarget(
            name: "Libuavs3d",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libuavs3d.xcframework.zip",
            checksum: "d3de4cfb1b2012332e1384337123872e1133651250227e592872eebfa1d13aec"
        ),

        .binaryTarget(
            name: "Libdovi",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libdovi.xcframework.zip",
            checksum: "c3d7d0696b4fc8b20bc0b90dede191c6b148cfa9a4c1f31b73c6f7cd83273523"
        ),

        .binaryTarget(
            name: "MoltenVK",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/MoltenVK.xcframework.zip",
            checksum: "9f8857a304f1db0f897a9733ca29f5e2b121ba42883570336c4748521274135d"
        ),

        .binaryTarget(
            name: "Libshaderc_combined",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libshaderc_combined.xcframework.zip",
            checksum: "aa8fd2ab4ad4e3ad28b1d813f846ac51a1cc718b266bf545c977ed5816a329cb"
        ),

        .binaryTarget(
            name: "lcms2",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/lcms2.xcframework.zip",
            checksum: "77385dbea5d3f336fc7810f26936780158d6ef1cf062c8aa6b7c28e294bdfee8"
        ),

        .binaryTarget(
            name: "Libplacebo",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libplacebo.xcframework.zip",
            checksum: "034f8cc33fffd51ee2881835f7e589390ed77816d49ff192762a94ff7e9dde5d"
        ),

        .binaryTarget(
            name: "Libdav1d",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libdav1d.xcframework.zip",
            checksum: "e38411470263eb8a3c59d7c3804e34b48ef1d5f9d26f955f35384e0419d14dce"
        ),

        .binaryTarget(
            name: "Libavcodec",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libavcodec.xcframework.zip",
            checksum: "3f299aa4d5319ffabb608d7865718d8163ad5cd1c877542b11546dbe4fbf22fc"
        ),
        .binaryTarget(
            name: "Libavdevice",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libavdevice.xcframework.zip",
            checksum: "8d00a328393f93bf7778a5be2a059822de2f5f5389830358842494ba187dedc8"
        ),
        .binaryTarget(
            name: "Libavformat",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libavformat.xcframework.zip",
            checksum: "1f4eeb92a8df28885d30a0b90ff6d27f9f56350e5864b6072b0e0bce3ab241ed"
        ),
        .binaryTarget(
            name: "Libavfilter",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libavfilter.xcframework.zip",
            checksum: "1224ab4575281ffb9d37ea8a4885b78d087fb860a7572313513e0c35a4243c7e"
        ),
        .binaryTarget(
            name: "Libavutil",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libavutil.xcframework.zip",
            checksum: "bf94bedbe640438388dbb2cbc2a33f3be54c5393686c1d18b9f8ce4b54102d9a"
        ),
        .binaryTarget(
            name: "Libswresample",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libswresample.xcframework.zip",
            checksum: "9afc8ace226b4561de255c53940cd2d715b1778db990500bd4723ae8346644ad"
        ),
        .binaryTarget(
            name: "Libswscale",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libswscale.xcframework.zip",
            checksum: "7c3886910b12d2abf5c2b37f2cdb0d0ee4743d0ccf44bd0c131ab8fe63e150ca"
        ),

        .binaryTarget(
            name: "Libuchardet",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libuchardet.xcframework.zip",
            checksum: "13a8670272d08768cb6ad6b339386b5d695449c825221ae0fe185b6f5a749660"
        ),


        .binaryTarget(
            name: "Libmpv",
            url: "https://github.com/iTushit/MPVKit-lobbycard/releases/download/1.0.0-lobbycard.3/Libmpv.xcframework.zip",
            checksum: "1f85287bd6c28cf0fe8c283440190a160f276bbd0548fa81174520514a2c82d8"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
