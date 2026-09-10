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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.145/WebP-1.6.0-alpha.145.xcframework.zip",
            checksum: "df5049f6b64b1a5718cde4fa315086e64df48f510d81e4446aa4200d86ee973a"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.145/WebPDecoder-1.6.0-alpha.145.xcframework.zip",
            checksum: "e0725b9f5d4befa0b155fea32f216170d585a46d3fd627ea17b7138e9c6b8c4f"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.145/WebPDemux-1.6.0-alpha.145.xcframework.zip",
            checksum: "83258a972ee31d14c7fa4cb00c6b0e12e31e2a38581f717ce6ddeb70f523d1c4"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.145/WebPMux-1.6.0-alpha.145.xcframework.zip",
            checksum: "5a6571d42b6807d67e947e95b8713363913e41c2d22df80177300598443656ef"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.145/SharpYuv-1.6.0-alpha.145.xcframework.zip",
            checksum: "0b3283428bd9e3b9d391227957605107037dadb8ebeaa8b422d91b2042ee2ce6"
        )
    ]
)
