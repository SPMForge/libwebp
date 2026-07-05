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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.78/WebP-1.6.0-alpha.78.xcframework.zip",
            checksum: "186a66a7ccc5e4d6e5072f531947899871f45fff6415f01b27cb281d91a212d8"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.78/WebPDecoder-1.6.0-alpha.78.xcframework.zip",
            checksum: "a46e4c24f8cf22cbb216dc3c025b2d727951049782f402e1f6a6cccdd484a2ca"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.78/WebPDemux-1.6.0-alpha.78.xcframework.zip",
            checksum: "84d11cde8bf0459063b0666b49b6b1a854cfe2dfacda27c85c2ff97b19a3b97a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.78/WebPMux-1.6.0-alpha.78.xcframework.zip",
            checksum: "5692cf5f1d3e0173f74f93bf1f123b8f922c39022960d40622a2829ccf89b78a"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.78/SharpYuv-1.6.0-alpha.78.xcframework.zip",
            checksum: "309f0ad94b7101cdc87198e08440774ab3e941ab676d9bca932b4f1834386964"
        )
    ]
)
