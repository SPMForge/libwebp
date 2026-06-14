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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.57/WebP-1.6.0-alpha.57.xcframework.zip",
            checksum: "98826dfe72455a9ef620598942f63171b2d9d103251335da3415cf6d3685c220"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.57/WebPDecoder-1.6.0-alpha.57.xcframework.zip",
            checksum: "92eaeac50a495c14ec516d5832dd3db0a931448461b7fa098cbf270ffa64f202"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.57/WebPDemux-1.6.0-alpha.57.xcframework.zip",
            checksum: "14710a497405ad1dedba4d5357ae3e633baf62d31941cce7960b951ab62dfe20"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.57/WebPMux-1.6.0-alpha.57.xcframework.zip",
            checksum: "2c764c7143e0e3654cb74ee7d6b8ef26b9c90a04579be5504c884ac3afaa0b9d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.57/SharpYuv-1.6.0-alpha.57.xcframework.zip",
            checksum: "602296f6c0f939797d1b970dfd8066eead7f8652f94867e81df37e5b99e141f6"
        )
    ]
)
