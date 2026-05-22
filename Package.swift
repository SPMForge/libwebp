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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.34/WebP-1.6.0-alpha.34.xcframework.zip",
            checksum: "da1107ae4b0da552ddf6bad308b2f923e86cc09479bbd5754f51d936221bf847"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.34/WebPDecoder-1.6.0-alpha.34.xcframework.zip",
            checksum: "6529bf12562f9ee43edf68b7a1f3b485bfa5981b7d5d7e9a5cfdb3212dbe5ee0"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.34/WebPDemux-1.6.0-alpha.34.xcframework.zip",
            checksum: "a0f9ed3aa34d55be1a749f07cd7a3db9d6105f865f2831422b8ab9f566cd4b79"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.34/WebPMux-1.6.0-alpha.34.xcframework.zip",
            checksum: "09094428377c544385e0fadeb9caa32596457407a16a8848757d4f1e8f48dedd"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.34/SharpYuv-1.6.0-alpha.34.xcframework.zip",
            checksum: "b7e5857a614050d93178b2b6d7d053c1f3f46f4fdaaea45cf5b3081c630b08d8"
        )
    ]
)
