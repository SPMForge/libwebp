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
        .library(name: "WebP", targets: ["WebP", "SharpYuv"]),
        .library(name: "WebPDecoder", targets: ["WebPDecoder"]),
        .library(name: "WebPDemux", targets: ["WebPDemux", "WebP", "SharpYuv"]),
        .library(name: "WebPMux", targets: ["WebPMux", "WebP", "SharpYuv"]),
        .library(name: "SharpYuv", targets: ["SharpYuv"])
    ],
    targets: [
        .binaryTarget(
            name: "WebP",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.7/WebP-v1.6.0-alpha.7.xcframework.zip",
            checksum: "e3d3173ae4ef5d9a94dd0c77ee761084574bd20970e1a7ccd8398b7c1ee8d81f"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.7/WebPDecoder-v1.6.0-alpha.7.xcframework.zip",
            checksum: "61942c5c7d556eca072d1a5db0d4c7969b5657e74e616346ae8e036e218a2962"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.7/WebPDemux-v1.6.0-alpha.7.xcframework.zip",
            checksum: "f26ceb7c3bcd1755ac4fc9b589b4867da655d9ae4342f09532eac11167d009e0"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.7/WebPMux-v1.6.0-alpha.7.xcframework.zip",
            checksum: "f3c0c9d139f8969f4ae900ea5f93d4339f0f70ab62c232b2da9fd104d3fcbece"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.7/SharpYuv-v1.6.0-alpha.7.xcframework.zip",
            checksum: "adc756c8b1d17f12a0d5e60395a850c720e4316d7589bfdc96a8856723ea016b"
        )
    ]
)
