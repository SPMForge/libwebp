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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.45/WebP-1.6.0-alpha.45.xcframework.zip",
            checksum: "61067851bf10f58f94cf0d3ec23c87c0189fcf32c4cfad57b252fdef4f96af14"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.45/WebPDecoder-1.6.0-alpha.45.xcframework.zip",
            checksum: "0c1671b80348ba0cae1bb6d6bedff379be284ffacd1e67ff996cc883f1b232f8"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.45/WebPDemux-1.6.0-alpha.45.xcframework.zip",
            checksum: "d3befec61171178f1aa553d3fc97ce90295229cdf721bf9688d99c100ab943ea"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.45/WebPMux-1.6.0-alpha.45.xcframework.zip",
            checksum: "4945ef3ab0fd838d40d481060bf1c3bbaedb7fedc21c44852e67d0c3ad7b0379"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.45/SharpYuv-1.6.0-alpha.45.xcframework.zip",
            checksum: "b4deee9f286bb75e95246373ad4b64ea0243b9d23ddfe7bcaa5fa622dd389be4"
        )
    ]
)
