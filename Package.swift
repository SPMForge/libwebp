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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.100/WebP-1.6.0-alpha.100.xcframework.zip",
            checksum: "be015013ac35f04b27a052044407aff9e1ea055ec4699ef11f0e5080f66be7b4"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.100/WebPDecoder-1.6.0-alpha.100.xcframework.zip",
            checksum: "bd7d71e9fa5e998e7fcf687cbd756d8f5dc670aadc18a6face5780eaa69a93e4"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.100/WebPDemux-1.6.0-alpha.100.xcframework.zip",
            checksum: "c466ce40426c399aebd5cb05b2a964dc2da9b8e66cec3f873094f3cf3960076d"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.100/WebPMux-1.6.0-alpha.100.xcframework.zip",
            checksum: "9f64f2c911363879d6fb49bf4a5a4ba627dddd31ecd10da98d6486a31e24960e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.100/SharpYuv-1.6.0-alpha.100.xcframework.zip",
            checksum: "8e80e15ca81eb730e069350d31c8b2ec4eb332772ea4909f59226c5d19f000a5"
        )
    ]
)
