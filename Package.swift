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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.9/WebP-1.6.0-alpha.9.xcframework.zip",
            checksum: "437484a8742800fc50f2ae98b1f2a197f90fc5416085b1f63e25fcfd0d60b773"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.9/WebPDecoder-1.6.0-alpha.9.xcframework.zip",
            checksum: "ef54ca9af375a2ce676aab4607432ff9352f36e3defbb05a16d3c8d105e92c9d"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.9/WebPDemux-1.6.0-alpha.9.xcframework.zip",
            checksum: "2a321448d54044649d71ba25c7bbea630b55a678154dd955074a530d4a660ab1"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.9/WebPMux-1.6.0-alpha.9.xcframework.zip",
            checksum: "ca35bb03378070015fe33bf27334d7c22ba618a1e8e9ae43cab715abe7a0e6a9"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.9/SharpYuv-1.6.0-alpha.9.xcframework.zip",
            checksum: "7f16b7bd87b010d171adc30d573add50de10868380301eea36c59a725b348ddf"
        )
    ]
)
