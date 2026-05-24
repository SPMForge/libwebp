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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.36/WebP-1.6.0-alpha.36.xcframework.zip",
            checksum: "48af62c9ce09834f38e5fa8efd2ac96067853a01db33ef3fa73267e05cda1e97"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.36/WebPDecoder-1.6.0-alpha.36.xcframework.zip",
            checksum: "0b773cb43eb537eead7ae1e576ac5cf33e0b1dd0d2e317f7b75f34cf3f63c003"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.36/WebPDemux-1.6.0-alpha.36.xcframework.zip",
            checksum: "aa0d2d07fb2bedb54977462b065ca0efa7add865b8f0963ca275ecbb5985c23a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.36/WebPMux-1.6.0-alpha.36.xcframework.zip",
            checksum: "8595f6c2ac059b39e82511bea85dffe8adac7a79fd14ce8353e6dae06cf67a80"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.36/SharpYuv-1.6.0-alpha.36.xcframework.zip",
            checksum: "774e4deae8a74d6e7abe08d8dd0e8349cc85de2bda79d10d46a0be43ae8b1cdc"
        )
    ]
)
