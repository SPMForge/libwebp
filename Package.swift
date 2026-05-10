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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.22/WebP-1.6.0-alpha.22.xcframework.zip",
            checksum: "e6e8ec8a9e3a3a848d2fa178e1c4dcb5b3efe99321c7cdf7de98a1f3ac86f631"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.22/WebPDecoder-1.6.0-alpha.22.xcframework.zip",
            checksum: "464d42c710c44d03462afd91949d9eb25fec6aa1dbff465efc119847b9f176c7"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.22/WebPDemux-1.6.0-alpha.22.xcframework.zip",
            checksum: "55436444f8bdc536dc23443de55d31d611dcf50510d8782a237438690f8558a1"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.22/WebPMux-1.6.0-alpha.22.xcframework.zip",
            checksum: "0f7db808f802ad9d4265a838350f7ec65e64dd0f5f440b6c8da907467481f428"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.22/SharpYuv-1.6.0-alpha.22.xcframework.zip",
            checksum: "edbe6cf311795dee70e80da2ac5137850c429e2c1e1b5eae740f2e01d956a02f"
        )
    ]
)
