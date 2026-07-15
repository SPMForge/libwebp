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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.88/WebP-1.6.0-alpha.88.xcframework.zip",
            checksum: "b2696d378ae326ebd57d5adce00ac5190e1ef59c3ce7a8fd347b3ddf543e5e97"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.88/WebPDecoder-1.6.0-alpha.88.xcframework.zip",
            checksum: "37446711bf57e6ae01c51179dc837e09f486730050c3bc981c4293d0e1a85269"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.88/WebPDemux-1.6.0-alpha.88.xcframework.zip",
            checksum: "a7c3a25a4ba59d9f5ff8e72167b0fd66d8f1a02223519fb7cfc699c103cdfd09"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.88/WebPMux-1.6.0-alpha.88.xcframework.zip",
            checksum: "168fcb76a42a645a834dd1d7270c09d96efa3c326ad870406ce2c529bc1d7221"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.88/SharpYuv-1.6.0-alpha.88.xcframework.zip",
            checksum: "0a7dd7c113fb56fd4bc40d04652a4201ea4e7945c416a86929cdb6650922f079"
        )
    ]
)
