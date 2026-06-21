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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.64/WebP-1.6.0-alpha.64.xcframework.zip",
            checksum: "82ab4ca1ff497069bf67243c97d8c2d282516dcf890c2d3a1f0f8a3838c2712d"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.64/WebPDecoder-1.6.0-alpha.64.xcframework.zip",
            checksum: "ab29f6a8a962fb20c557ecc0bfd61361617240d3bddc98c5e118cc3914cdbbde"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.64/WebPDemux-1.6.0-alpha.64.xcframework.zip",
            checksum: "3d20c1967512162e431497c893ada747426bbcedaab97baba3ae7864a7a48bcb"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.64/WebPMux-1.6.0-alpha.64.xcframework.zip",
            checksum: "e2a9f3e7735626835ec53ddfa63aafb8871a9a41ab28b4c53e60f0ab163bf224"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.64/SharpYuv-1.6.0-alpha.64.xcframework.zip",
            checksum: "3881ae5330d4243c6dab102b7128c9ca0393896d094202543bbabc866f14d0b8"
        )
    ]
)
