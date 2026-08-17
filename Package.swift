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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.121/WebP-1.6.0-alpha.121.xcframework.zip",
            checksum: "30fc244abde20eafb3468d0d23d98ffc0757e9618fd379c87272a218179afd09"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.121/WebPDecoder-1.6.0-alpha.121.xcframework.zip",
            checksum: "d5c5a9ef35068373ede16297fe6dfd313830e2f9fe8bbddb1cba5ebf7c5448fc"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.121/WebPDemux-1.6.0-alpha.121.xcframework.zip",
            checksum: "16dede684e491ea142e60ef6de7e71ef9378e240d53d91a0a7eb082f67a99f02"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.121/WebPMux-1.6.0-alpha.121.xcframework.zip",
            checksum: "6d7dd4cbc191012f771428419ddbacf62fa45ef05aee74fafb348b7135051f42"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.121/SharpYuv-1.6.0-alpha.121.xcframework.zip",
            checksum: "9f8a0202e4cb6c31fcec8cde60129b0d5b04e1bc4ac0b4cc10c8fb22f9f658c1"
        )
    ]
)
