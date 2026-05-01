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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.13/WebP-1.6.0-alpha.13.xcframework.zip",
            checksum: "c32077e5a20641bf3fa53ed8e54a3c415251821ccb44bd1f063e69576cb72972"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.13/WebPDecoder-1.6.0-alpha.13.xcframework.zip",
            checksum: "f0205c57d80c1a759c736be380fb64539373c4e3317c31eafb82eacc99ccd84e"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.13/WebPDemux-1.6.0-alpha.13.xcframework.zip",
            checksum: "8a9887e5d225daca1afd8df0ef48317e2d8b4382a4a330783c0c9bd95c8641ca"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.13/WebPMux-1.6.0-alpha.13.xcframework.zip",
            checksum: "23429f1e8389f5548c6fcab26120bf7a2b48b80f09db8c37e54be72050419c6c"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.13/SharpYuv-1.6.0-alpha.13.xcframework.zip",
            checksum: "178ea5198f917c9b000ca38989cf908ed2b3eceecb613b42d42c9b65476626af"
        )
    ]
)
