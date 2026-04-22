// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "libwebp",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v8),
        .visionOS(.v1)
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
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.10/WebP-v1.6.0-alpha.10.xcframework.zip",
            checksum: "60c348643ee717b54142dffc3a630eff88039badc3534a8b594a1414643c05c1"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.10/WebPDecoder-v1.6.0-alpha.10.xcframework.zip",
            checksum: "65a2d83acfcede1aa95bbb03201a18e0e50cf993f961411beade1533ab4f9c99"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.10/WebPDemux-v1.6.0-alpha.10.xcframework.zip",
            checksum: "638d61cf621a0cea363a6087cad1ad9a772a9a20f67cb7e520d79eab37bf1e7a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.10/WebPMux-v1.6.0-alpha.10.xcframework.zip",
            checksum: "a819c5a54c3341e4846b73063955a4c1aedd792d813a084b0c7cae68cbcd0e95"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/v1.6.0-alpha.10/SharpYuv-v1.6.0-alpha.10.xcframework.zip",
            checksum: "7ebd24d2eef9f8be85177c4c3b53fead3304e8b3d22a81e6907fe58d2e1ac1f2"
        )
    ]
)
