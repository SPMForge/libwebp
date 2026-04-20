// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "libwebp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "WebP", targets: ["WebP"]),
        .library(name: "WebPDecoder", targets: ["WebPDecoder"]),
        .library(name: "WebPDemux", targets: ["WebPDemux", "WebP"]),
        .library(name: "WebPMux", targets: ["WebPMux", "WebP"]),
        .library(name: "SharpYuv", targets: ["SharpYuv"])
    ],
    targets: [
        .binaryTarget(
            name: "WebP",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.3/WebP-v1.6.0-alpha.3.xcframework.zip",
            checksum: "a6be478c4c04cdf8680520c82040a17d3870b435d997e186eb73744e61773bf0"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.3/WebPDecoder-v1.6.0-alpha.3.xcframework.zip",
            checksum: "b91b63b255ee247b5f40bc9bec07852ba06075b18d23e0b9edeffd0e28702f63"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.3/WebPDemux-v1.6.0-alpha.3.xcframework.zip",
            checksum: "28a8fd9ad473ed4aa906935a86f23957a4ddcb56d5d28687a1e459a23d80a51b"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.3/WebPMux-v1.6.0-alpha.3.xcframework.zip",
            checksum: "a3706e1dd347109cce28db86b393ce7e5f2b1d30c90ac24f47808cf8efae544e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.3/SharpYuv-v1.6.0-alpha.3.xcframework.zip",
            checksum: "09c478f3bc32dd6060552bbfea34149ac2abba577286123f308863e5e1adc716"
        )
    ]
)
