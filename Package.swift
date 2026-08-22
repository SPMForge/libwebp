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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.126/WebP-1.6.0-alpha.126.xcframework.zip",
            checksum: "575244968da211c56afcae699abe301ef3dec55e3055430ab65659bae69bc376"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.126/WebPDecoder-1.6.0-alpha.126.xcframework.zip",
            checksum: "ddfbff50b5277490b9bf670f48d9c06b9a82eaa11a56c51fc72c7a26d002e32a"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.126/WebPDemux-1.6.0-alpha.126.xcframework.zip",
            checksum: "c127cdb99ac1e94115056f6be5e6616c354bd2f56df73d05576cd3e438b249f9"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.126/WebPMux-1.6.0-alpha.126.xcframework.zip",
            checksum: "f6f5d341a5a248eefe619e386e5bd36e67c0af608abab48a8067f20fa2febf4a"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.126/SharpYuv-1.6.0-alpha.126.xcframework.zip",
            checksum: "e315067576805a5f1205a3ad560001378c63697939a361008d2c2e16a1a5bf2e"
        )
    ]
)
