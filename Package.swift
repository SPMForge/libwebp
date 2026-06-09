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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.52/WebP-1.6.0-alpha.52.xcframework.zip",
            checksum: "b5a88bb9dc9ec9d75a944041a7c3dce4830fafca56d4b7a2a70c07e01f1d4a93"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.52/WebPDecoder-1.6.0-alpha.52.xcframework.zip",
            checksum: "557bb46f3caf48e386515f9938b92b7fd4142191dbff030eda6058a05a79cb07"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.52/WebPDemux-1.6.0-alpha.52.xcframework.zip",
            checksum: "3fcae72d90bf292b18601cd1d8a8a01a7648a55a2d723be7b726556c3f06c3a0"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.52/WebPMux-1.6.0-alpha.52.xcframework.zip",
            checksum: "b7866faf351e7def211c34866cdb015d3e4afba28dc4eb8dafe6260896ab5033"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.52/SharpYuv-1.6.0-alpha.52.xcframework.zip",
            checksum: "6ff545e8b840f30f0a0eca27b5723781872fdcf4e31d8cef08cefe14e377d23b"
        )
    ]
)
