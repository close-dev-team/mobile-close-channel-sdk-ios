// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CloseChannel",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "CloseChannel",
            targets: ["CloseChannelBinaryTarget", "CloseChannelBinaryWrapperTarget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/TakeScoop/SwiftyRSA", from: "1.8.0"),
    ],
    
    targets: [
        .binaryTarget(
            name: "CloseChannelBinaryTarget",
            url: "https://github.com/close-dev-team/mobile-close-channel-sdk-binary-ios/archive/refs/tags/1.7.1.zip",
            checksum: "6dd838c50dc2932add1b37119cbda7bcbfff74c58b2c15369df853532b35f390"
        ),
        .target(
            name: "CloseChannelBinaryWrapperTarget",
            dependencies: [
                .product(name: "SwiftyRSA", package: "SwiftyRSA"),
            ],
            path: "./Sources/CloseChannelBinaryWrapper/"
        )
    ]
)
