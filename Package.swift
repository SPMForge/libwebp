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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.125/WebP-1.6.0-alpha.125.xcframework.zip",
            checksum: "fe40d26e5f2b6c5578ec3c7f0273d00a5b055a9b2fb5a5d2d8ed4ed62173b061"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.125/WebPDecoder-1.6.0-alpha.125.xcframework.zip",
            checksum: "1331e4f636f70344dcd1a05030a668b14e08e5922dfd39a69ec6ae7a02be5140"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.125/WebPDemux-1.6.0-alpha.125.xcframework.zip",
            checksum: "4a175c1e56bb54259920ba3d48a24a99ddd51aeef1455a0ccd7d73ecc4fc1168"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.125/WebPMux-1.6.0-alpha.125.xcframework.zip",
            checksum: "3be7d1bf248ccaa05ca185493fefd121162cd7ba8d654efeb839d6d4ad4c4397"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.125/SharpYuv-1.6.0-alpha.125.xcframework.zip",
            checksum: "b6df784ef302bd4f8a88d3a5455a076d34f1784dfd2655da635d0df3a55fa5d9"
        )
    ]
)
