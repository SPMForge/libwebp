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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.122/WebP-1.6.0-alpha.122.xcframework.zip",
            checksum: "a6aacf439d9bdbdd844dcbcb229a8e52d87da2c4820f4713c1d183cb785dfd3e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.122/WebPDecoder-1.6.0-alpha.122.xcframework.zip",
            checksum: "73408b88869651bf12175dd1743ec162382dcf0e2470315d8dd81e0fce73759c"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.122/WebPDemux-1.6.0-alpha.122.xcframework.zip",
            checksum: "00dcfa7e1034c094278018d1e2a2da0f279ff1068a71c5146be0ab42fc5651cb"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.122/WebPMux-1.6.0-alpha.122.xcframework.zip",
            checksum: "74bb6b97f8ab22bccc77e2286d271830e9677262120dd74931e4eac0cc2b1728"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.122/SharpYuv-1.6.0-alpha.122.xcframework.zip",
            checksum: "516bb442d290736f945f18e0fb13dcf2fb945e101da64f01566579b41c8a9e35"
        )
    ]
)
