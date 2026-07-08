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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.81/WebP-1.6.0-alpha.81.xcframework.zip",
            checksum: "93dc088fa29be17dfaed8bd9c632198c4a74f7557fdcf98a75ad62a523e6bc7c"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.81/WebPDecoder-1.6.0-alpha.81.xcframework.zip",
            checksum: "e893b991c55982e7bd58d6904249774555692fafeec40da3d08506b0ebee04d2"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.81/WebPDemux-1.6.0-alpha.81.xcframework.zip",
            checksum: "9a00ef38ac16cec2b8f7012c58f883c02eeb2aef1cd876fb27518fc0bace45f3"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.81/WebPMux-1.6.0-alpha.81.xcframework.zip",
            checksum: "381b05ee520ea8bd0d825abc15260333e29f543566d1bee1de66e016a7fc37ce"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.81/SharpYuv-1.6.0-alpha.81.xcframework.zip",
            checksum: "df8ca86ce571a1bd7f24e2399947002d0bcdb77d6267397d23b8536126d0c76d"
        )
    ]
)
