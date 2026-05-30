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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.42/WebP-1.6.0-alpha.42.xcframework.zip",
            checksum: "9e50ffd9f7a7ecf3c41dfbdaa59d15d763e6acfcd9cb7239edee7c607ee2c76c"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.42/WebPDecoder-1.6.0-alpha.42.xcframework.zip",
            checksum: "56d044cd2247c462281db3f7d290916c0f377b92113bdb7c536fec204093c7c6"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.42/WebPDemux-1.6.0-alpha.42.xcframework.zip",
            checksum: "78bf3db8ed2763526af04a35a70873caa8309586ded0b953e34bdf3f651c07c5"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.42/WebPMux-1.6.0-alpha.42.xcframework.zip",
            checksum: "ba8b7b359981fd3653296c587c473c4aadf01cdb2db6d1ea428dac7f3971e833"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.42/SharpYuv-1.6.0-alpha.42.xcframework.zip",
            checksum: "5824b1db5aeb390af9fd51d7766794e45d1942b4fb6d2e8931957c2acb331175"
        )
    ]
)
