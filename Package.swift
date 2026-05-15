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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.27/WebP-1.6.0-alpha.27.xcframework.zip",
            checksum: "b869dde29569a238bd7bfc9016c2838e588440fe19a67473bd2f1b1b15ec2c3b"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.27/WebPDecoder-1.6.0-alpha.27.xcframework.zip",
            checksum: "2ab447176bcd4f83da2e840680d0f0c2d56b9b897357f98dd8f27265806e7e24"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.27/WebPDemux-1.6.0-alpha.27.xcframework.zip",
            checksum: "162db4cd8300bdb56a3ef801e735c08bbae7d50a3f3fe30b86eca1e144cc60e4"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.27/WebPMux-1.6.0-alpha.27.xcframework.zip",
            checksum: "90f7bd192d3c8d33e1950c2d75c22d9784d496cb092de32fddd6e4deab64d9d7"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.27/SharpYuv-1.6.0-alpha.27.xcframework.zip",
            checksum: "490cb1efb442b99b848cd0ef802620fcca77ed1dd47249547baee66c961cb900"
        )
    ]
)
