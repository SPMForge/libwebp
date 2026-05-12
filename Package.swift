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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.24/WebP-1.6.0-alpha.24.xcframework.zip",
            checksum: "9b47820edd74ede6170be80a4295f8b7cf74dc58329ff2f77f91fecd36eb8525"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.24/WebPDecoder-1.6.0-alpha.24.xcframework.zip",
            checksum: "b9a5d49300a079d3770e5becf867b69b45f7dcdd7162e82fdd2bd5d71f89ff51"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.24/WebPDemux-1.6.0-alpha.24.xcframework.zip",
            checksum: "b8cda8ed8e73a820ff731c73eed5de8a0e0404bf222d3fd19872b34d48f367bf"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.24/WebPMux-1.6.0-alpha.24.xcframework.zip",
            checksum: "b77179ce71624e62709455e9fc8487d607e1e1062fd542c3588448ec21c4f570"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.24/SharpYuv-1.6.0-alpha.24.xcframework.zip",
            checksum: "8f1478d1565d3fcc40429dc30bcd20f0b09b3a395d6f31ab5ab11687403aa945"
        )
    ]
)
