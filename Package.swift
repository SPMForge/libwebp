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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.33/WebP-1.6.0-alpha.33.xcframework.zip",
            checksum: "43659428408df21a4bcf7933724f7f185657e1bcd3aad6c0a86574d84781ffbb"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.33/WebPDecoder-1.6.0-alpha.33.xcframework.zip",
            checksum: "03966dbc8386d803b2f985158ebc3e6ba092be3e1d3c056e114b2ab6cd862a68"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.33/WebPDemux-1.6.0-alpha.33.xcframework.zip",
            checksum: "296967a805311b49ce8f8c04d60c58f16c2b64d7ccda385edbe908431019f068"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.33/WebPMux-1.6.0-alpha.33.xcframework.zip",
            checksum: "6eb9a217006ad22366ccdd257be4177fb498a43316f58b4ecd161011f53888bc"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.33/SharpYuv-1.6.0-alpha.33.xcframework.zip",
            checksum: "89d17dab9923f43c0c30bf1151adddbbd960c10123049b33007218fabf6b1459"
        )
    ]
)
