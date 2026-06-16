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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.59/WebP-1.6.0-alpha.59.xcframework.zip",
            checksum: "3a0baff95e11761b9b3670c1f063045704440bfaa8739b53568df46d989e810b"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.59/WebPDecoder-1.6.0-alpha.59.xcframework.zip",
            checksum: "c7db4c5a96b895378eff327f748145f396f77aee1089df807826348da7e10b57"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.59/WebPDemux-1.6.0-alpha.59.xcframework.zip",
            checksum: "032ffa08581bdba5d5ef06b58edc6eeae86538d2f4ff11de839eb09ddbbaf894"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.59/WebPMux-1.6.0-alpha.59.xcframework.zip",
            checksum: "2ec8cda277fbfebac121f478302a2b2c7ce3e55bec8375a89f8783121cc444fb"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.59/SharpYuv-1.6.0-alpha.59.xcframework.zip",
            checksum: "f32f5adf8845b1eb68147cd4c39587911aabe135a87817d63269bc9b7200693c"
        )
    ]
)
