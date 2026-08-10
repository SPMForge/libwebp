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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.114/WebP-1.6.0-alpha.114.xcframework.zip",
            checksum: "79e25a97eba677867ad192620a9ac1d31475f1a37628020fde2c99ea087d6f87"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.114/WebPDecoder-1.6.0-alpha.114.xcframework.zip",
            checksum: "7f51468a1d452651d24d3bee8c23fe5923beac6eb4be9fba43abe5578455e7e6"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.114/WebPDemux-1.6.0-alpha.114.xcframework.zip",
            checksum: "ca6de5282409a2a455dc3cd54f8f17fa3317af311bb7797e6a593394e1ac9e98"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.114/WebPMux-1.6.0-alpha.114.xcframework.zip",
            checksum: "a7be1ddc9bf07a1b51d833285799fe2ff80962c82b7ac0a29c386b5fecc91d14"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.114/SharpYuv-1.6.0-alpha.114.xcframework.zip",
            checksum: "aaf7bf34c2d5a4ae42020e153fe0aa4a16234ba2511eca5f4f49f210ec30f60c"
        )
    ]
)
