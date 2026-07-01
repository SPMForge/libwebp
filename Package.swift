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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.74/WebP-1.6.0-alpha.74.xcframework.zip",
            checksum: "ab0101bee54e20af1de21532b20d39d9c6fa49852a2c64f0d756434a1b5d6e60"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.74/WebPDecoder-1.6.0-alpha.74.xcframework.zip",
            checksum: "22a675f54e96860dca6661abe61a36ea0586b6a1f2a64a5411a793210ded1173"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.74/WebPDemux-1.6.0-alpha.74.xcframework.zip",
            checksum: "af6fdcb165d82d04fa03ab7c315c1bd1306e98b966e073aea2149a91353b6959"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.74/WebPMux-1.6.0-alpha.74.xcframework.zip",
            checksum: "92c4363c7b857c9b6dbfeadd27c3662650c452c7ed611d5e83e0f63cf70d99f4"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.74/SharpYuv-1.6.0-alpha.74.xcframework.zip",
            checksum: "8b3254ca3c297aa004cf2e667cb9782f63a89c986236a3b460acfbb57676c11d"
        )
    ]
)
