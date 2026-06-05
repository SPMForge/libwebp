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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.48/WebP-1.6.0-alpha.48.xcframework.zip",
            checksum: "82aeb799a99d1c17d336a41b98ae950fcdd3f6d63ee747c0afbad3e6703b6b24"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.48/WebPDecoder-1.6.0-alpha.48.xcframework.zip",
            checksum: "ca06c55e07181bd0fa51949d21c9ac6b209124802cf3a6357fe2885ebaf1fca0"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.48/WebPDemux-1.6.0-alpha.48.xcframework.zip",
            checksum: "e2d532e6b0f81534de08c740554170044df1694251c1ccf1f4acc8f137c3a1ad"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.48/WebPMux-1.6.0-alpha.48.xcframework.zip",
            checksum: "b95a28f4eb0b6a193c29c259c18ae3693d79694adcb902ef70e5bfdacd11d77e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.48/SharpYuv-1.6.0-alpha.48.xcframework.zip",
            checksum: "0165c8c232059b05fa7fa7ded522f24bdc9b1e48c43a933e5fe03bcd8b9896bc"
        )
    ]
)
