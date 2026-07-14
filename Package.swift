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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.87/WebP-1.6.0-alpha.87.xcframework.zip",
            checksum: "263da7206b41bb34bd9cfff786f10caf1f3f0f08965830e217fee4beb0a6dcb0"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.87/WebPDecoder-1.6.0-alpha.87.xcframework.zip",
            checksum: "878b6e5ca4260022828a889fa4ff583de4a5add573a3281088783398de1b76be"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.87/WebPDemux-1.6.0-alpha.87.xcframework.zip",
            checksum: "d168654ee2ea62e315e5020071bf5a13450ce99939c5d62253d2982b7799d060"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.87/WebPMux-1.6.0-alpha.87.xcframework.zip",
            checksum: "4cfc91dd12e34a0e9b85de5bf1581afaa277431f0960806ded099dfe290a1d93"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.87/SharpYuv-1.6.0-alpha.87.xcframework.zip",
            checksum: "af46ccfe9bc59ea83e928c01229bb307dbc74c7544dc7c70511e7348dada0a97"
        )
    ]
)
