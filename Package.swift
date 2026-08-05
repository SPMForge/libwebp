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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.109/WebP-1.6.0-alpha.109.xcframework.zip",
            checksum: "c5ab035ddc0813c69972e6fa41133d48f75fe3348b81431ac341660deb2c30a9"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.109/WebPDecoder-1.6.0-alpha.109.xcframework.zip",
            checksum: "cb6504e50dce509b8c4b9bd7490036da7785dd6c5f9688e9228e7c66cec4832e"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.109/WebPDemux-1.6.0-alpha.109.xcframework.zip",
            checksum: "9b6b348d55e48e8fd5d8efdd70bcfce48fbcb62c266e6306b9f09db739eade2a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.109/WebPMux-1.6.0-alpha.109.xcframework.zip",
            checksum: "7e9a1981e3352705ce833d20ac7defaae0bca5ce0d1c4d9761b2420cbe06ccdc"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.109/SharpYuv-1.6.0-alpha.109.xcframework.zip",
            checksum: "b04cfbb8366328c981c4cc44d2a48017e4234e7dc323ce9705c6ebf5d04445e7"
        )
    ]
)
