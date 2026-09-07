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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.142/WebP-1.6.0-alpha.142.xcframework.zip",
            checksum: "497cdca70d9ae68455f06c92b33733d060f185c22da15de69cef75746e6acb31"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.142/WebPDecoder-1.6.0-alpha.142.xcframework.zip",
            checksum: "d1c13234b5100370ff364677679cf95e4e8a6677a073d1ec780f7ebb77164e09"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.142/WebPDemux-1.6.0-alpha.142.xcframework.zip",
            checksum: "c9b4666d521118cf6f14e853490c4c75bcc7b9bf48dbfa035ab60bb5a973217a"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.142/WebPMux-1.6.0-alpha.142.xcframework.zip",
            checksum: "c0e26c1ad7cc2ac5592bc172aa09ebfc61fa332bcd5ab1bc51362768e897f06c"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.142/SharpYuv-1.6.0-alpha.142.xcframework.zip",
            checksum: "79b6fd266cd66ad9bea03274398e0716ecd0a550647fb026829aad12547dc67f"
        )
    ]
)
