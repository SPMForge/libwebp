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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.110/WebP-1.6.0-alpha.110.xcframework.zip",
            checksum: "f779ec8658e61d74b399e508f1f63847d1311fdf8aa5de5ae3413ae928b7c015"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.110/WebPDecoder-1.6.0-alpha.110.xcframework.zip",
            checksum: "5c9a546df6b76712c0aa697b7dd332e9c3eb83a78d304f5a10ff63d6d2dae584"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.110/WebPDemux-1.6.0-alpha.110.xcframework.zip",
            checksum: "0c74a12433685ba329f320545acda5e235f14cd6aa6d0169442a2dd5b35e41bd"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.110/WebPMux-1.6.0-alpha.110.xcframework.zip",
            checksum: "af737c4f05e620b0fb4dbd1d1cee341725d38f058b13e8bcef82582fac001fe2"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.110/SharpYuv-1.6.0-alpha.110.xcframework.zip",
            checksum: "bd7c95ec1f72ef8e4c6fe0c3068ec7017adefbd28bdffc6acdfb286b45989319"
        )
    ]
)
