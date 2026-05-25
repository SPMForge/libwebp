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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.37/WebP-1.6.0-alpha.37.xcframework.zip",
            checksum: "d843dc732f37235cf1bedc8122e90a3f0498f4cae76740fc24f359c93b987402"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.37/WebPDecoder-1.6.0-alpha.37.xcframework.zip",
            checksum: "9d4f59782501a4aa13d6eef0596d712a8f518941b7d5beb9218e61714e26231b"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.37/WebPDemux-1.6.0-alpha.37.xcframework.zip",
            checksum: "43aee5919f958e57d2c76662dc41772a98649dded6d7261c7946f9d087094c75"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.37/WebPMux-1.6.0-alpha.37.xcframework.zip",
            checksum: "4553f080bc4b4b22e4f37c8a458c1b7834c6547470d521a93beada24da97a4d1"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.37/SharpYuv-1.6.0-alpha.37.xcframework.zip",
            checksum: "807745d289401c6faa3394cf363236941b3dc9a675841d4ed90fbff024d8a718"
        )
    ]
)
