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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.63/WebP-1.6.0-alpha.63.xcframework.zip",
            checksum: "97e8c3adad733366ba3a483da7ad8d785beb1269d3244b87927769918c9caab7"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.63/WebPDecoder-1.6.0-alpha.63.xcframework.zip",
            checksum: "00f415dacc11389b91437d484b8dca04c71ef7c7d3f5cb6d4b8b7bd5ec2c316c"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.63/WebPDemux-1.6.0-alpha.63.xcframework.zip",
            checksum: "28878f9a8ee9b6994ad5d225026635659f779356cd17cc8ac2436aaf945ec261"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.63/WebPMux-1.6.0-alpha.63.xcframework.zip",
            checksum: "ff379c29ade44a8a213a61055a3f7c0c4d36effc29366d1661be9bdc3ccb2c82"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.63/SharpYuv-1.6.0-alpha.63.xcframework.zip",
            checksum: "b15233a709d335ac8c913184727d4e909de686ecd01a8b530d2546b0149b247c"
        )
    ]
)
