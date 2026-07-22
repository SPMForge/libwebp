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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.95/WebP-1.6.0-alpha.95.xcframework.zip",
            checksum: "62750aa2e647904420cd974f2363cec94595e4d64c092b5df83415e67522135b"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.95/WebPDecoder-1.6.0-alpha.95.xcframework.zip",
            checksum: "911a7a42326a6722881267429fb7e3ba995573a5b77a1c318c6ddda408a1de98"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.95/WebPDemux-1.6.0-alpha.95.xcframework.zip",
            checksum: "ae43131740fdb76eddc4b2e0dc9bd18ba8986ede3efa41ae86d8867484a86583"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.95/WebPMux-1.6.0-alpha.95.xcframework.zip",
            checksum: "37577643da90e9514d9588889361ab8caee7bddb673fac1a1e428dbef4f7c800"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.95/SharpYuv-1.6.0-alpha.95.xcframework.zip",
            checksum: "a44db0aa70b50eb176826e94d34d640bd34e628f7b4333fdca2f0d57228a4bea"
        )
    ]
)
