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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.79/WebP-1.6.0-alpha.79.xcframework.zip",
            checksum: "b09676722e0382c5069f68f047a2e030b19cdc33d2e6bd7d96f4fcd85130bdac"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.79/WebPDecoder-1.6.0-alpha.79.xcframework.zip",
            checksum: "d4a7186772cf808d62578724854d2ff4ea4100a95677c72183a085b7d2cf4e0d"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.79/WebPDemux-1.6.0-alpha.79.xcframework.zip",
            checksum: "5370ce311a21604605c253cb0f9f7a5dcfbacf9001dd68bb3e9b02c1a5c518f4"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.79/WebPMux-1.6.0-alpha.79.xcframework.zip",
            checksum: "d47004307047cfeee58b6702092ab362c936ed387197152c56aa9c08fb2b2fcc"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.79/SharpYuv-1.6.0-alpha.79.xcframework.zip",
            checksum: "42490148f5a7ad549ad6a41a7ba82ee64492f9b4bbf3af8aed67eaaf1194ae02"
        )
    ]
)
