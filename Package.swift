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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.21/WebP-1.6.0-alpha.21.xcframework.zip",
            checksum: "3e0957999b3461128987d29d0e25bf95fbf343ef88b70cf0e667bb47bd4f2a51"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.21/WebPDecoder-1.6.0-alpha.21.xcframework.zip",
            checksum: "775673a372190a8eb1a07b0b1c35e7bd5dd8d81ac7b88ea2470180140f9c6bd9"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.21/WebPDemux-1.6.0-alpha.21.xcframework.zip",
            checksum: "1be9790ffa549505e87b7ed47e48ad81c171cc903822f4cb5388929cbe3fca4b"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.21/WebPMux-1.6.0-alpha.21.xcframework.zip",
            checksum: "f92c3ec7ce33282c4d1581d9b6bbf5e29e885cd9ea3a77c9b99d05b091765327"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.21/SharpYuv-1.6.0-alpha.21.xcframework.zip",
            checksum: "576ff4789ee3899ecfe8f1b5fe4cc610071651ea1706f1c5e5a8f7c2d90f47fb"
        )
    ]
)
