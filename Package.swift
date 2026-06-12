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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.55/WebP-1.6.0-alpha.55.xcframework.zip",
            checksum: "bb3612597bbdf24e8fca573980c9c465e19dc610aab4e39e66469b15b4ebfb80"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.55/WebPDecoder-1.6.0-alpha.55.xcframework.zip",
            checksum: "c83d8d11b25105dd9e04842aedb7f4fa6f854558ed3674322ac9f0c6d650e6f4"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.55/WebPDemux-1.6.0-alpha.55.xcframework.zip",
            checksum: "b3a5b97bf236e44f2d37c05053102b0454002351080fc6bde2079c688d773d33"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.55/WebPMux-1.6.0-alpha.55.xcframework.zip",
            checksum: "3ca5ad4dd14eda2cb204349112a364f1edd88a727b2e0224b2e3b07edf2eee87"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.55/SharpYuv-1.6.0-alpha.55.xcframework.zip",
            checksum: "76ae9943398cb4ae61ac0b41ef96219651ab388cb5b9938083ea689a4c5988e4"
        )
    ]
)
