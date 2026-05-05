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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.17/WebP-1.6.0-alpha.17.xcframework.zip",
            checksum: "1d7f36d4f363afdefa9f07c9ca37da87463b703c19b810368b47fdf8d6aa3336"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.17/WebPDecoder-1.6.0-alpha.17.xcframework.zip",
            checksum: "aa71858c46fd6e84e7c8585d4dc1110d39a9fc3f06b4cd06df2d24d1b04c95f2"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.17/WebPDemux-1.6.0-alpha.17.xcframework.zip",
            checksum: "cda96d36489cec78c24758badcdf1c47fef4c33e7e0a8280d1059bfd9a925b26"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.17/WebPMux-1.6.0-alpha.17.xcframework.zip",
            checksum: "09c5f07c4ebdb8c63798e66329a8591d70ef1783c94bf2121df6ae8020b744b9"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.17/SharpYuv-1.6.0-alpha.17.xcframework.zip",
            checksum: "8a319c5610f597652e690d8004eed5f4d867e87e4d19e0534d94ace6f27df7ec"
        )
    ]
)
