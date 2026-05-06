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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.18/WebP-1.6.0-alpha.18.xcframework.zip",
            checksum: "601517ef6d56aa04005579c05699d4701932ec4c9acc9ce033b04549d85cd0b4"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.18/WebPDecoder-1.6.0-alpha.18.xcframework.zip",
            checksum: "acaf0ebba834d5b716bca25dcf8ddaff6b6df0532f8ba76d73746432f6a0dbee"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.18/WebPDemux-1.6.0-alpha.18.xcframework.zip",
            checksum: "fa36ef4d5c6bda5e6212c28f88bdb35a1515a0edad48f9592b223319f1c1cbd1"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.18/WebPMux-1.6.0-alpha.18.xcframework.zip",
            checksum: "090ffeb17c8e7aa861dc426bde87974b94201ebc1eae834727fdb0ce82fba1e2"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.18/SharpYuv-1.6.0-alpha.18.xcframework.zip",
            checksum: "d589032a602793986be27bae68de7dfedc002631254702a83bde75dd79f07a56"
        )
    ]
)
