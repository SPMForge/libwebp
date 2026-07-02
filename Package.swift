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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.75/WebP-1.6.0-alpha.75.xcframework.zip",
            checksum: "19d4fd2963f26b9137dc5c78d2010aa4abb5ae4bfcf69757e077228ea0769211"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.75/WebPDecoder-1.6.0-alpha.75.xcframework.zip",
            checksum: "f7d2df561e51e2f4057b6d5db52036bf4310cc42cbf24afce028f2d518542f10"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.75/WebPDemux-1.6.0-alpha.75.xcframework.zip",
            checksum: "0990fe5dec4fe0c8b0f5ca455dea0139e971c82ad2369df2415532d407aff574"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.75/WebPMux-1.6.0-alpha.75.xcframework.zip",
            checksum: "1f3e08f96eed2c7894829fdfe82e91d3e0a075b63a9fe09aff58d0203659ff2b"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.75/SharpYuv-1.6.0-alpha.75.xcframework.zip",
            checksum: "52793d45781ab9a1588fc068a0f2fee2248544ddd02662a8669c908c11aa561b"
        )
    ]
)
