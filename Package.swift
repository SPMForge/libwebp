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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.98/WebP-1.6.0-alpha.98.xcframework.zip",
            checksum: "a9c1b7af8083ee3cbf1a2a3599f22a2bc2ff3dea721cd247584a50ca0399d0de"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.98/WebPDecoder-1.6.0-alpha.98.xcframework.zip",
            checksum: "0f70425f11137f05aed7a59837910a7474d05bd66577a0f7c3b657501a4a2cd7"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.98/WebPDemux-1.6.0-alpha.98.xcframework.zip",
            checksum: "d5fa7cb620b467eb4d0cf397cf93f162d9e86370e078b0447d35c0897e827abd"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.98/WebPMux-1.6.0-alpha.98.xcframework.zip",
            checksum: "1f7ca7489c1339d27c74b652e846f32d2ab147a8cfee99de3e11c604c11abd76"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.98/SharpYuv-1.6.0-alpha.98.xcframework.zip",
            checksum: "7737111ff33ae03f047fb2e444cb8649d2662d182f9b282df1579353ccfce938"
        )
    ]
)
