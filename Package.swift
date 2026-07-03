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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.76/WebP-1.6.0-alpha.76.xcframework.zip",
            checksum: "48347ab8cc300641270b28ca8f549519883796607611235358126f36a1447fca"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.76/WebPDecoder-1.6.0-alpha.76.xcframework.zip",
            checksum: "627aa506cddb7054412f6d519f10602c0ab3d7677b26163bfc2016c4b4b4abb9"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.76/WebPDemux-1.6.0-alpha.76.xcframework.zip",
            checksum: "7defc15daebf24e4240f2ec08866e4bd8ee1e0d1f70e0c52f0edfc6642cdc71d"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.76/WebPMux-1.6.0-alpha.76.xcframework.zip",
            checksum: "0fb6c3d4babfc48f8911d0813682c6a01cd3b7a24d8d12e926822154af5daaec"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.76/SharpYuv-1.6.0-alpha.76.xcframework.zip",
            checksum: "d9a90478a160be7e64b2296a38bba078400893cec2033a85601bf94b33635a5d"
        )
    ]
)
