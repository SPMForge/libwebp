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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.82/WebP-1.6.0-alpha.82.xcframework.zip",
            checksum: "588db76cedb1e3192e4bd9d4d5211898c7da3e19dbcfde9d7207adc72e113cc5"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.82/WebPDecoder-1.6.0-alpha.82.xcframework.zip",
            checksum: "05c40b123c9289a4d165bf8f7e2793acfd0f46654ada8189ea79e7ca57217fed"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.82/WebPDemux-1.6.0-alpha.82.xcframework.zip",
            checksum: "c0a17f07d3ae7efb4fd8e5c885dd60b6af2e665a22d1a5b759b11e7739dc85ca"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.82/WebPMux-1.6.0-alpha.82.xcframework.zip",
            checksum: "a57dd74645e492e5e687a6ee6b8b163e1097e61ab9605f01fcccf5d11d0faec4"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.82/SharpYuv-1.6.0-alpha.82.xcframework.zip",
            checksum: "0e5f31200d6525d7260bb215c8a00ea8d2dadec4dface43fa475ac9b0e8ae85e"
        )
    ]
)
