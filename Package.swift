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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.116/WebP-1.6.0-alpha.116.xcframework.zip",
            checksum: "4c51298a97741f3d4a48dd962e8d88f7664cbcdd74fb740f8e4c1652c4261c59"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.116/WebPDecoder-1.6.0-alpha.116.xcframework.zip",
            checksum: "5dbcabd91cabf47e5aa7ef87e16488f6b84e9a2a63e6662b3a62f2e91ab082fa"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.116/WebPDemux-1.6.0-alpha.116.xcframework.zip",
            checksum: "dbc4c1c7d3ae6f7a770499b9cb7c58a10c17c502a2df18a5adb9a47bce0ce2e7"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.116/WebPMux-1.6.0-alpha.116.xcframework.zip",
            checksum: "a702dc0868236e4a2113aaa1615210f405e59940d9d5281c8bbb6188c5124cc0"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.116/SharpYuv-1.6.0-alpha.116.xcframework.zip",
            checksum: "e6ef21c73228eab7e374a96ba0a5ef16b0c33333516806ae61c93ade26ed2fd3"
        )
    ]
)
