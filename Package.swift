// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "libwebp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "WebP", targets: ["WebP", "SharpYuv"]),
        .library(name: "WebPDecoder", targets: ["WebPDecoder"]),
        .library(name: "WebPDemux", targets: ["WebPDemux", "WebP", "SharpYuv"]),
        .library(name: "WebPMux", targets: ["WebPMux", "WebP", "SharpYuv"]),
        .library(name: "SharpYuv", targets: ["SharpYuv"])
    ],
    targets: [
        .binaryTarget(
            name: "WebP",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.127/WebP-1.6.0-alpha.127.xcframework.zip",
            checksum: "a91ea6e912d8e42ff8c8096b22577c1398e1cfc57a2f2467d73afe46665ca699"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.127/WebPDecoder-1.6.0-alpha.127.xcframework.zip",
            checksum: "1122b3f2a83412b6e571d409cb32cb38ee1558dac56da5cade9b39a7e8d2a42b"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.127/WebPDemux-1.6.0-alpha.127.xcframework.zip",
            checksum: "f3d6193ceb12ce1fd159f251ca848b4070c5150a63e956f5ff5172e33f9ab2cf"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.127/WebPMux-1.6.0-alpha.127.xcframework.zip",
            checksum: "157e3fdb1cefa63ac5de29f1a1317b1d14ef9719c2a2958f9828e0ea7f3f356e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.127/SharpYuv-1.6.0-alpha.127.xcframework.zip",
            checksum: "641098c126d5a4cb2d1ec283cc73123cd8b26873b486153126e8e65acfde92ce"
        )
    ]
)
