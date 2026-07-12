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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.85/WebP-1.6.0-alpha.85.xcframework.zip",
            checksum: "761c90853bd0ba82e8fd9cdbde76bc9f2e4b59d14841a9ae9b2401433d14a43b"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.85/WebPDecoder-1.6.0-alpha.85.xcframework.zip",
            checksum: "0aff0965899f2fdd2ff9c14394f872a993957d48c06937a408f0ade02b866910"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.85/WebPDemux-1.6.0-alpha.85.xcframework.zip",
            checksum: "02f7ecea591c8cc5e39a9904f5b8e820ff5d2a0cccbed99c03b15c53e7b467cc"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.85/WebPMux-1.6.0-alpha.85.xcframework.zip",
            checksum: "d74efb533461ed9db7ecdd2e48b7dcf4d1398f1e47f378cc032116b26c8c5ec8"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.85/SharpYuv-1.6.0-alpha.85.xcframework.zip",
            checksum: "27e7fe1634d4fc0e6b0e5333f61cc87b4ea402f5245833e0be25d4e544200a75"
        )
    ]
)
