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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.39/WebP-1.6.0-alpha.39.xcframework.zip",
            checksum: "7a7c26995b819c424d06ce20dcac5451b05191c9a4f6fba2f19ec28de471554e"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.39/WebPDecoder-1.6.0-alpha.39.xcframework.zip",
            checksum: "7e2f789a2e8ab068e34bea25097266985652edc2bdd3a51106547d5081b91ccf"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.39/WebPDemux-1.6.0-alpha.39.xcframework.zip",
            checksum: "fe69eac502ea4701c37b631482c40aab521e858333b8c7689c63b620e32a7d94"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.39/WebPMux-1.6.0-alpha.39.xcframework.zip",
            checksum: "390daae4377fe7c829cd75a81b45f578bc92db76a60e772b87dab19835ae509b"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.39/SharpYuv-1.6.0-alpha.39.xcframework.zip",
            checksum: "43d71dbb8586e11b53a2eb7d58d3f47e3450e8e467bf755e4c80b9024f3ab29a"
        )
    ]
)
