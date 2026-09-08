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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.143/WebP-1.6.0-alpha.143.xcframework.zip",
            checksum: "de7374f0d0cca74d60b4da88a4902c1a89f7292e04a9c80ee9d615b6989b9a70"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.143/WebPDecoder-1.6.0-alpha.143.xcframework.zip",
            checksum: "e54064fa74e5f6be7f74ef2b3fb42dacdf44fceb742260cb86e4d5931e1276be"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.143/WebPDemux-1.6.0-alpha.143.xcframework.zip",
            checksum: "c3ae378e7b2efdc9eb2ac66ddb6ade36da8b4f5a6eef387d4e5814398e81af12"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.143/WebPMux-1.6.0-alpha.143.xcframework.zip",
            checksum: "65f167dc8cf638eec7b2cec4b5ebd0cb1ebb209a876672247634313b2852275b"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.143/SharpYuv-1.6.0-alpha.143.xcframework.zip",
            checksum: "a08b85761ecb6551c7f37ae2d3bd957a05b8f2ff9bb19c89fca3becd3b485d3e"
        )
    ]
)
