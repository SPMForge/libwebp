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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.69/WebP-1.6.0-alpha.69.xcframework.zip",
            checksum: "b5dd61b7fd528438b003a1d620831ef32a6b0348012bf2a51a669d0c09ee7d1e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.69/WebPDecoder-1.6.0-alpha.69.xcframework.zip",
            checksum: "f49c8e5acb4d23fef9b017cd195d27ae093b1657d46091cb7deb2315c0de6c7b"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.69/WebPDemux-1.6.0-alpha.69.xcframework.zip",
            checksum: "31e0c46476ba47142b29a76cb34d0a337927e8ed81d6a26cc8ac92c36df5a738"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.69/WebPMux-1.6.0-alpha.69.xcframework.zip",
            checksum: "65267aeabaaee45c9f28a638664035ea37f08ebfd2dee0cb2c2abff91ecbf64d"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.69/SharpYuv-1.6.0-alpha.69.xcframework.zip",
            checksum: "cd7abffc5adf7649108550bbed1e371e37cd804e773b53f00c6bd50a5b39a991"
        )
    ]
)
