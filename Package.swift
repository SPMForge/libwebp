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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.139/WebP-1.6.0-alpha.139.xcframework.zip",
            checksum: "e63eee782b8dc37576080110efacb17b549e6249043649059704243b7485c7c2"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.139/WebPDecoder-1.6.0-alpha.139.xcframework.zip",
            checksum: "04a35b549c96eabb7230505d49919a3f00edaf8480bcbc961342559ad41a0029"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.139/WebPDemux-1.6.0-alpha.139.xcframework.zip",
            checksum: "81545ef1b61933fe45bc610165512e1e5496b92e35cc30e8956da6990c2380d7"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.139/WebPMux-1.6.0-alpha.139.xcframework.zip",
            checksum: "e94d03d91c3c8013f5163034c5f87107a7755c778ba098ace368c243ba4d61b1"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.139/SharpYuv-1.6.0-alpha.139.xcframework.zip",
            checksum: "856ce8cd60a1c7bfc07bffe83f1b7257f7442259ef0862f00969f2a580f098ee"
        )
    ]
)
