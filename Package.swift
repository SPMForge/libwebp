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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.14/WebP-1.6.0-alpha.14.xcframework.zip",
            checksum: "7e4e90f36859d91d2588deecde6149799deac302e081c893e63d7df7266cac40"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.14/WebPDecoder-1.6.0-alpha.14.xcframework.zip",
            checksum: "1c63de37bf9ca1aca5733f177fdf496d94caf43e3eeac07878692a4f05954de8"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.14/WebPDemux-1.6.0-alpha.14.xcframework.zip",
            checksum: "11d966155624afb43d52b222b657d032752f2d8d1845f5a550594c0857150fa5"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.14/WebPMux-1.6.0-alpha.14.xcframework.zip",
            checksum: "28a2d1b2ac708cd407e21e82cf917a39271bac4ba477399a0e2264d08fc46afb"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.14/SharpYuv-1.6.0-alpha.14.xcframework.zip",
            checksum: "75ff09762f9a58a44d7b7d2200024ad78b9840d32ed9020505c5505d3c3e4566"
        )
    ]
)
