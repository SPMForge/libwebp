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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.129/WebP-1.6.0-alpha.129.xcframework.zip",
            checksum: "fa00cbaa8ecc908d4019453735b89938c40bbdeebf358454fc611792a24538c2"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.129/WebPDecoder-1.6.0-alpha.129.xcframework.zip",
            checksum: "b37285e8ad3a1d24d3e679f8194c77ff23d665a3d0ce2329139c7e35f23bc3bb"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.129/WebPDemux-1.6.0-alpha.129.xcframework.zip",
            checksum: "6ad2d7db58056666e48d3f8d72213ea7984fd060be199a7eef52f227ef004b3b"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.129/WebPMux-1.6.0-alpha.129.xcframework.zip",
            checksum: "01f2d9f564da8a70bccc0736e66a679804c588a48f0f80c89550263f4f32ef56"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.129/SharpYuv-1.6.0-alpha.129.xcframework.zip",
            checksum: "6691d2ff779bf710163ddfc680d5ae45bcc0074485d658a18aaded17489c5ad7"
        )
    ]
)
