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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.73/WebP-1.6.0-alpha.73.xcframework.zip",
            checksum: "273baab5fc349c1aa80dd881a25fc4669b5553ea5d10a94bdeb3478acdc58eaf"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.73/WebPDecoder-1.6.0-alpha.73.xcframework.zip",
            checksum: "9b58462b69fa8731c3fa78aa1ba3eeb65ff015471c1a8dfbf69b3a6a1cebb1f0"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.73/WebPDemux-1.6.0-alpha.73.xcframework.zip",
            checksum: "23481357cda4150735cafa4636f7ed28c683e57c41c8578d354c75b58b4f31cc"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.73/WebPMux-1.6.0-alpha.73.xcframework.zip",
            checksum: "3be842a70a1e69dd14438b86b611ff9bf3722fa0e4ef20b496cf0b9ea4d7bc69"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.73/SharpYuv-1.6.0-alpha.73.xcframework.zip",
            checksum: "32d41cabeea0d34763b82a0bf9f7d407bafb8de49a9a6d16ace58358dc4204a1"
        )
    ]
)
