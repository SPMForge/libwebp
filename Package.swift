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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.46/WebP-1.6.0-alpha.46.xcframework.zip",
            checksum: "1fe3f266af902518bf2ae4a6f4978acf6735e164bd0f39d63b8866ee4d9f9d21"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.46/WebPDecoder-1.6.0-alpha.46.xcframework.zip",
            checksum: "9880751d4285dceeff6065fde0b978c9901e4b3d126621b955bccd49dd067523"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.46/WebPDemux-1.6.0-alpha.46.xcframework.zip",
            checksum: "82cb4e3180f8a73f11b84334921d9ac1d032e37f1bc365262744a7ef069ae629"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.46/WebPMux-1.6.0-alpha.46.xcframework.zip",
            checksum: "9942f44c88a46194eb1880c852faf3cc544c13e1af94aaa67e20fbe8e05850eb"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.46/SharpYuv-1.6.0-alpha.46.xcframework.zip",
            checksum: "8c93e4a2977ee6394d74ad69f5ea44ab211f771397bc62c85f100d0e18a86288"
        )
    ]
)
