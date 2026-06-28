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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.71/WebP-1.6.0-alpha.71.xcframework.zip",
            checksum: "3ca192c598b320e82e42dc25216fd68c0a9ab3930425e4f7b9b5e5ae6a17f8f9"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.71/WebPDecoder-1.6.0-alpha.71.xcframework.zip",
            checksum: "d7da6af558b171a2a552294ce0116491ec62c0039991ac7d0e6e5bfc632d79e9"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.71/WebPDemux-1.6.0-alpha.71.xcframework.zip",
            checksum: "1cb92752d6896882c5e0a309efca1f47c5cb4b68453f7db347fa3e58ee30bf51"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.71/WebPMux-1.6.0-alpha.71.xcframework.zip",
            checksum: "20292d2179d41091700f4828c113a7e776c712d09dc658f7ab11dcb93058a638"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.71/SharpYuv-1.6.0-alpha.71.xcframework.zip",
            checksum: "d4d0d151724e2abd0bc2197ab3154db5d241b487ae25ae90df8087075c931e94"
        )
    ]
)
