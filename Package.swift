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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.40/WebP-1.6.0-alpha.40.xcframework.zip",
            checksum: "d7f4c45807be7a5a57d775940473492aad8772b8239415771cb471c6d0b8a107"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.40/WebPDecoder-1.6.0-alpha.40.xcframework.zip",
            checksum: "b822477118a1189e6278ff30e65383545db3de03baeabd16d599eb651784defb"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.40/WebPDemux-1.6.0-alpha.40.xcframework.zip",
            checksum: "3424e9f49ae9c47c1c08e9dd666b73d6b2f54576145ba8728ce1c478e678c5cd"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.40/WebPMux-1.6.0-alpha.40.xcframework.zip",
            checksum: "8c14eda3d1bf5ce330326461a9626e48051685a233a6b61ee4ffe9257da4b413"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.40/SharpYuv-1.6.0-alpha.40.xcframework.zip",
            checksum: "213dc03035398e482495df38b0064e68e8d0a5e373be2982362e4c9733a89416"
        )
    ]
)
