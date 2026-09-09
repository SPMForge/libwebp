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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.144/WebP-1.6.0-alpha.144.xcframework.zip",
            checksum: "cea3c9b6f744d031f738fdd9c8e83b15a9898d74d2e1dae80ec86d219853101e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.144/WebPDecoder-1.6.0-alpha.144.xcframework.zip",
            checksum: "00c1a9ce3077af07a74757221ee989a03b9f9b81b210712467f65075ade7c610"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.144/WebPDemux-1.6.0-alpha.144.xcframework.zip",
            checksum: "58bac729ba22711b7e8ded992f583a5cb017759d5ff4f5ee58b12610cd5e7ebd"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.144/WebPMux-1.6.0-alpha.144.xcframework.zip",
            checksum: "05df0a7ff60cbeba9f625a1a6529101f6d9ef71df93e69522b5992808abcd7bb"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.144/SharpYuv-1.6.0-alpha.144.xcframework.zip",
            checksum: "ef81c11a743128beadb063031c833e5bc576ee2d93880f18f01a6e1fa22dc4fb"
        )
    ]
)
