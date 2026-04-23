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
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.4/WebP-1.6.0-alpha.4.xcframework.zip",
            checksum: "7f889a3a9347248b9dce2de284d0645c4dd5cd38f41d9fb34ebfd0a53ef7e4ce"
        ),
        .binaryTarget(
            name: "WebPDecoder",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.4/WebPDecoder-1.6.0-alpha.4.xcframework.zip",
            checksum: "c2892994a7bbd6640a2300e40fff117eca53268d04bf82654eb191f661311d03"
        ),
        .binaryTarget(
            name: "WebPDemux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.4/WebPDemux-1.6.0-alpha.4.xcframework.zip",
            checksum: "e5d22f174425b56b548d7ca98bc2ea89cb0283f3f3acf1c5b942018515611035"
        ),
        .binaryTarget(
            name: "WebPMux",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.4/WebPMux-1.6.0-alpha.4.xcframework.zip",
            checksum: "7cc194e09515a89a5dc31008c009143e44fc4b10b7429f98906596191899273c"
        ),
        .binaryTarget(
            name: "SharpYuv",
            url: "https://github.com/SPMForge/libwebp/releases/download/1.6.0-alpha.4/SharpYuv-1.6.0-alpha.4.xcframework.zip",
            checksum: "908fd0c4c455bc7c463f6a55f9f0e9c1e539648048c18eb4ab50e284423415df"
        )
    ]
)
