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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.113/WebP-1.6.0-alpha.113.xcframework.zip",
            checksum: "d8af25260c3177ea8fe92f73350d1e6256e0f641407a21afa7f94d786c7c8167"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.113/WebPDecoder-1.6.0-alpha.113.xcframework.zip",
            checksum: "01f7579ab184be8555176a091765b7f637345bce1f3df208fcc2300e5bc2fb19"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.113/WebPDemux-1.6.0-alpha.113.xcframework.zip",
            checksum: "cf59cdf6168ac7eeb720f31df031e5411659ddcd7ff11c9d808887de44d798e7"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.113/WebPMux-1.6.0-alpha.113.xcframework.zip",
            checksum: "c4446d53543c7fa8e1d37ebb5e695cef8e5b9a08e93633228d7f638ac12732a7"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.113/SharpYuv-1.6.0-alpha.113.xcframework.zip",
            checksum: "0fa74427bcaf8da67a6d6eadb31a05534f28cec111f55c9e942d6089bf1d10eb"
        )
    ]
)
