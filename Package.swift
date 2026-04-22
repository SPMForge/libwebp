// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "libwebp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1)
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
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.11/WebP-v1.6.0-alpha.11.xcframework.zip",
            checksum: "9f7017b71ea91750b8e8272f7132bea35a8a5fc9b22c83e2842c496ef228a904"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.11/WebPDecoder-v1.6.0-alpha.11.xcframework.zip",
            checksum: "dd63d56fa6bc1a356c89707899841ec52148968913d61d403c9d019eef637678"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.11/WebPDemux-v1.6.0-alpha.11.xcframework.zip",
            checksum: "ba7cba88978c3152b47f1426491fe4787dba111237c8e2bbfc95533206ed54ee"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.11/WebPMux-v1.6.0-alpha.11.xcframework.zip",
            checksum: "7ef0ca3de294bf2387959cd9a79300e299239a710aee7a6f428b83a220475e1d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.11/SharpYuv-v1.6.0-alpha.11.xcframework.zip",
            checksum: "8025e1b5424d17eccc57c9274ec05bc73ef9a34340d11e299a549bb64c65a4f2"
        )
    ]
)
