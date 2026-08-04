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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.108/WebP-1.6.0-alpha.108.xcframework.zip",
            checksum: "2e6b2516ead23ba35d6290677e414c7ac3e04b28aa1108cb5fe8d81a5ea89514"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.108/WebPDecoder-1.6.0-alpha.108.xcframework.zip",
            checksum: "945c6448f70be1960a2921ee5e57a766d5e66ba9a70fb6f97b2a073481e521d8"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.108/WebPDemux-1.6.0-alpha.108.xcframework.zip",
            checksum: "e4f053df8a57efe335bd88361b0bdfdfabdd2b16ff3d085f1c5c9e277b5c608f"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.108/WebPMux-1.6.0-alpha.108.xcframework.zip",
            checksum: "494aff1df1cba3c6ab08223ecfd6a4e291e8a537c0cf2efec68a40875e4cc36e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.108/SharpYuv-1.6.0-alpha.108.xcframework.zip",
            checksum: "3a9a202842ff64b1c156df83bb0c266b1230cf3fb0a69bb61ce6b5ba706547a0"
        )
    ]
)
