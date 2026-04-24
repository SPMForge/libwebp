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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.5/WebP-1.6.0-alpha.5.xcframework.zip",
            checksum: "3976cafbca3b82bafa38d051c531c55d17ddf99f2f573191417ed1e6cbb5ef81"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.5/WebPDecoder-1.6.0-alpha.5.xcframework.zip",
            checksum: "648a0d12a27fb49131196916c427ffa407dd08f47d3076618574aa1f951ca391"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.5/WebPDemux-1.6.0-alpha.5.xcframework.zip",
            checksum: "0e0bd0ad707fc93ad869f907e9ffafb79139ab925a28e75bbb01cad2feef5093"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.5/WebPMux-1.6.0-alpha.5.xcframework.zip",
            checksum: "cfcf23f49a8e6cb1a5a4e46f87a2543a5fdd18c77e2aa67c7e3464062acc6d7e"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.5/SharpYuv-1.6.0-alpha.5.xcframework.zip",
            checksum: "a705b8e4586581e0ca35fa7b33679bee10712324fc43c0d46ed2e3023ba47ba9"
        )
    ]
)
