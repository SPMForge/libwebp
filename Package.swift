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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.72/WebP-1.6.0-alpha.72.xcframework.zip",
            checksum: "130413a52f012f1163f1a9b8fc88c2b99b5728b131d6f32c5f1caec8cce96acb"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.72/WebPDecoder-1.6.0-alpha.72.xcframework.zip",
            checksum: "2a6c7de5b6132d3899eceae40c6d1969cfe2f39f793c73c2f1d32c8c5902f32b"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.72/WebPDemux-1.6.0-alpha.72.xcframework.zip",
            checksum: "21778a90df0119bf94069f3341636402c9d4dc10c4633b063438bd37e605faa3"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.72/WebPMux-1.6.0-alpha.72.xcframework.zip",
            checksum: "620280a9de9cff5e5ed5cfbb63570418be00f2a12949565e658d2a80d56b2025"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.72/SharpYuv-1.6.0-alpha.72.xcframework.zip",
            checksum: "6a3a9a6e4f791a5dc7f8e4b26854089978de092b2d88c1a595bcf851a09bcd60"
        )
    ]
)
