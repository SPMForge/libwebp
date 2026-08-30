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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.134/WebP-1.6.0-alpha.134.xcframework.zip",
            checksum: "107bba71faf0cead2ecee9b4ecd7e35fdf8bee77aafc9ed1b0c9156dd1e45c67"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.134/WebPDecoder-1.6.0-alpha.134.xcframework.zip",
            checksum: "462c000b4a230ea147f7d0bb9876f56cf761f0b9be9ac4b9b55cab225dd4739c"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.134/WebPDemux-1.6.0-alpha.134.xcframework.zip",
            checksum: "68f7eb5e2db3c9cef751e341555999bd4127605da438b838ce8d12ca99a973c0"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.134/WebPMux-1.6.0-alpha.134.xcframework.zip",
            checksum: "fe544c198c0f976a4adf1d2eb84f670c1de0b7c66efb2595681ed7626f3c7cc5"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.134/SharpYuv-1.6.0-alpha.134.xcframework.zip",
            checksum: "2c2d22fe8d4f3a87694a2b1178643537bf62d9d8d2eb080d7f11ef50e1682a3b"
        )
    ]
)
