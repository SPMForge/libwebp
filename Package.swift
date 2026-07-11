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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.84/WebP-1.6.0-alpha.84.xcframework.zip",
            checksum: "bb260dec01d4eca03d413aeed3029bf7066b4b5104d7cbeb0e22a86df9604ff2"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.84/WebPDecoder-1.6.0-alpha.84.xcframework.zip",
            checksum: "67d036690b16f3cc4d08b095034dce8c31b8bd5faa6b750622d93c9eb1e47184"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.84/WebPDemux-1.6.0-alpha.84.xcframework.zip",
            checksum: "3023cf77e799a24b708da0148cb4d01e406fe3d77434ef7eaabaa8aa154eff73"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.84/WebPMux-1.6.0-alpha.84.xcframework.zip",
            checksum: "594bbd4656c3d59bbbc667e0d2b3a5b780d2af12c4893f93dd86ed3c76ac0f1d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.84/SharpYuv-1.6.0-alpha.84.xcframework.zip",
            checksum: "597c5cf5f56bc003b7e96e8760fb6a4e31e18f523243d0f1f691badcae0ff39a"
        )
    ]
)
