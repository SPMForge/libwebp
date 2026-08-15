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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.119/WebP-1.6.0-alpha.119.xcframework.zip",
            checksum: "caaae8d62522a5fcbe3a132b7d5b4df78140366c4448c11c29ebf374fc08dcf7"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.119/WebPDecoder-1.6.0-alpha.119.xcframework.zip",
            checksum: "7f23f274d643f8424feb94108d167bbace5d72c96a23d25253ce4dcb0dcedec5"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.119/WebPDemux-1.6.0-alpha.119.xcframework.zip",
            checksum: "939117f01a0c277835e61c2261e161ca60bc2adf2f36e6f8de0d7c0895610762"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.119/WebPMux-1.6.0-alpha.119.xcframework.zip",
            checksum: "cb49567e5f8c1c14ca59304292c59753bf8ae2c0086d37ce24a4a6f2ae78fcd5"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.119/SharpYuv-1.6.0-alpha.119.xcframework.zip",
            checksum: "98f37e5b831570077dd3eec464b87b2c078623328bc2196c98791cdba5ef079c"
        )
    ]
)
