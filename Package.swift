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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.138/WebP-1.6.0-alpha.138.xcframework.zip",
            checksum: "1bf5b254df13eec509fba7e8d8df1d997c7fe55edde353dcf198581c060ee19b"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.138/WebPDecoder-1.6.0-alpha.138.xcframework.zip",
            checksum: "da97992933a35740bc496ff02cd9160491a3d3be5f8ac25163e6d2b17a6a315c"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.138/WebPDemux-1.6.0-alpha.138.xcframework.zip",
            checksum: "4cd5ca142597fcb354b9e3d64b0b355d2564fd043d94df9ab60621336bde1ddd"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.138/WebPMux-1.6.0-alpha.138.xcframework.zip",
            checksum: "12211eba52f3a58e164c12b14fb8f4871262d11d7b7aeefbaf5ce85c417b66f0"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.138/SharpYuv-1.6.0-alpha.138.xcframework.zip",
            checksum: "882319bf31f7d356999af16685ccf655029a039e17f806a2e8f4c8af9df2468f"
        )
    ]
)
