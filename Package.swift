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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.92/WebP-1.6.0-alpha.92.xcframework.zip",
            checksum: "99ca5ed2ddc13a485e06a7d4366a30614e015e36d2f37ea5050c0f74bb65ea2e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.92/WebPDecoder-1.6.0-alpha.92.xcframework.zip",
            checksum: "a6418904d12586902d0baf29e42f0639e0d9a0525db6cc63380df4bc976ef44a"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.92/WebPDemux-1.6.0-alpha.92.xcframework.zip",
            checksum: "8e1de39a217ff87ec59eeaff19e6e83eec8f712faff91a8402dc0d116350efb1"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.92/WebPMux-1.6.0-alpha.92.xcframework.zip",
            checksum: "a45c63c58d17ccca0378a7e7b4142ef4d1f6f61256bfe9bf0f50d73b15482c8c"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.92/SharpYuv-1.6.0-alpha.92.xcframework.zip",
            checksum: "792bea15ee9db1b475412db66dbfe633a46fca75c8915027cff1c1ec898af941"
        )
    ]
)
