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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.31/WebP-1.6.0-alpha.31.xcframework.zip",
            checksum: "780ed001ad0577245e465c796f6f86cadfcaf59d6e87f472d88d5390a11cdb65"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.31/WebPDecoder-1.6.0-alpha.31.xcframework.zip",
            checksum: "3ba93c3f5769fc3bd4bcb550d57aba2ce527e273b31d9c91782eac2fcf3740aa"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.31/WebPDemux-1.6.0-alpha.31.xcframework.zip",
            checksum: "34142eb6dadaf9d581e4be6ae107d1e39a7932d404aa90e465238b65c6ebcc26"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.31/WebPMux-1.6.0-alpha.31.xcframework.zip",
            checksum: "b8424ae81dde378bc7f6e738b645763bcf508eb467e3534e60bf07ef91e14272"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.31/SharpYuv-1.6.0-alpha.31.xcframework.zip",
            checksum: "e626a377168f0fe5829190ffbcc1746a303aaeb7ccb515bbcfb1a08bc59d3061"
        )
    ]
)
