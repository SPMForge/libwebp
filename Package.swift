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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.107/WebP-1.6.0-alpha.107.xcframework.zip",
            checksum: "bf9b76c77d55e7937a8f79c27a1b3f0f1f2e426a51b0d63a79721b7fbe958bbf"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.107/WebPDecoder-1.6.0-alpha.107.xcframework.zip",
            checksum: "00e046625885a07334f1960e77ff5645e4df745664fd554c3f9840685fb5bc2f"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.107/WebPDemux-1.6.0-alpha.107.xcframework.zip",
            checksum: "8b5cc436e35e31cce0c8dafb1c0f2e2ea565598b0e642fc39da585f433d4b65f"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.107/WebPMux-1.6.0-alpha.107.xcframework.zip",
            checksum: "c335519e1eb6b4254c8a16658160d70e00b152038eea3f82e2dd8588e984b385"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.107/SharpYuv-1.6.0-alpha.107.xcframework.zip",
            checksum: "bd3dcb8ab49a7cda0f202c60dc22086fb6baf2d0dc5ad1c7327c4f9979ae0ef8"
        )
    ]
)
