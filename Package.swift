// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "libwebp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "WebP", targets: ["WebP"]),
        .library(name: "WebPDecoder", targets: ["WebPDecoder"]),
        .library(name: "WebPDemux", targets: ["WebPDemux", "WebP"]),
        .library(name: "WebPMux", targets: ["WebPMux", "WebP"]),
        .library(name: "SharpYuv", targets: ["SharpYuv"])
    ],
    targets: [
        .binaryTarget(
            name: "WebP",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.4/WebP-v1.6.0-alpha.4.xcframework.zip",
            checksum: "25308baa0dd43bdf8d66644bbdbc2fe3b6c36749828f08822c9163bf13d504e0"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.4/WebPDecoder-v1.6.0-alpha.4.xcframework.zip",
            checksum: "a45dd1c91c0b2e5c48eaef1498ff08df56f7e8bf2ff36277aef54bdf8701fac9"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.4/WebPDemux-v1.6.0-alpha.4.xcframework.zip",
            checksum: "73a7f5f648a2a48a2c1d4de4332163b48c6dd0680def1406b84b804041021e76"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.4/WebPMux-v1.6.0-alpha.4.xcframework.zip",
            checksum: "88995b04ba9ae90bdee649f1bd631b5c72dd4c6393bd52931b6c9d230213fb63"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.4/SharpYuv-v1.6.0-alpha.4.xcframework.zip",
            checksum: "287271ff6baaf607a95f4edf6f2ae11bdcb5b5e323d441fbb7e8352603e39a44"
        )
    ]
)
