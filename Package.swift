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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.8/WebP-1.6.0-alpha.8.xcframework.zip",
            checksum: "d3d822c6eacbdb386fd50c32afe04c9339993c3b8cade169a9dff8d7a688770d"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.8/WebPDecoder-1.6.0-alpha.8.xcframework.zip",
            checksum: "71e7ca101dbeab09c3f26429f0443153c0daf033c782c6c85fb75b03a9ebfa83"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.8/WebPDemux-1.6.0-alpha.8.xcframework.zip",
            checksum: "3f525f63dbbd985274ea6a009d916d668ae814aa2bc7057785f82103bbf154bc"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.8/WebPMux-1.6.0-alpha.8.xcframework.zip",
            checksum: "de6fffc3d6444d31ad27394768f2f5d840fbe5882e7d4da6c0ce1b6ab9c68f4a"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.8/SharpYuv-1.6.0-alpha.8.xcframework.zip",
            checksum: "6f4d1bdae7255d177b784ef746ffb3d124bad67709ff33f7c41aa1df27939255"
        )
    ]
)
