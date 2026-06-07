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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.50/WebP-1.6.0-alpha.50.xcframework.zip",
            checksum: "a182d759e9892a094a5e75f42b703ec5b52059cb855763cf3a3ee32c9c66b001"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.50/WebPDecoder-1.6.0-alpha.50.xcframework.zip",
            checksum: "b7a8e3c11c9c0ceeb46de4fa43bb54cd53183fd8f0d3ac97734c54d052607eac"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.50/WebPDemux-1.6.0-alpha.50.xcframework.zip",
            checksum: "b68b7625c7dc9be120edd883227dc2fa9e6f772da59e12ed2d1bfe7544032895"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.50/WebPMux-1.6.0-alpha.50.xcframework.zip",
            checksum: "97616c13b9c89c174f2f2cb66f12567daff8a04d51d95cab77d5524acf721e4b"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.50/SharpYuv-1.6.0-alpha.50.xcframework.zip",
            checksum: "c18c67413cbe3edc45df26383ec060945f86ae9b9e5f83cd33bb334df110ab78"
        )
    ]
)
