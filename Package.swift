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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.101/WebP-1.6.0-alpha.101.xcframework.zip",
            checksum: "5db850eeeb0c6da47eb8d924f32a16f6fd210fd5002e9ab5f6f04d48e3a887e7"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.101/WebPDecoder-1.6.0-alpha.101.xcframework.zip",
            checksum: "5a29e5dca5c2e645b3913bfdfea71a8d4a4c95eaae2b0524c34fe41a790daf10"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.101/WebPDemux-1.6.0-alpha.101.xcframework.zip",
            checksum: "46e4d34018f538941c0f09a5775304aabb34bd1aeb75b08c858d979d3763253e"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.101/WebPMux-1.6.0-alpha.101.xcframework.zip",
            checksum: "2262b733124e4cd77fb590997b35deaec0bf1c5a71270bcd201a9b150f456dd1"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.101/SharpYuv-1.6.0-alpha.101.xcframework.zip",
            checksum: "4894e864379ff74c8851854f737103dbb0c7d41e86a02e4cba856ff5f17b4f03"
        )
    ]
)
