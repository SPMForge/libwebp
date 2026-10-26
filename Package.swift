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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.191/WebP-1.6.0-alpha.191.xcframework.zip",
            checksum: "2983e0ceb2b9ce0b5ec18cbbfb34c2ca18b577444c5e235d6bea4a093b49d787"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.191/WebPDecoder-1.6.0-alpha.191.xcframework.zip",
            checksum: "786848108b134bc1e4449ab7a6f751470e9170ee32de78af4fedc90e596aaaa6"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.191/WebPDemux-1.6.0-alpha.191.xcframework.zip",
            checksum: "4f9bc0c85b34a72da9fb23557e4b723ea87569fb03e9e068617a8da6ad9547ed"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.191/WebPMux-1.6.0-alpha.191.xcframework.zip",
            checksum: "ec65521f168305a05596094fe8349464276afa1673fc91c9493b9a5946417987"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.191/SharpYuv-1.6.0-alpha.191.xcframework.zip",
            checksum: "4a0abc5ca46617f9a36d4a39a8133c700d1ec24f7ec7ee5f4accf1229e51c87d"
        )
    ]
)
