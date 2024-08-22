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
            url: "https://github.com/close-dev-team/mobile-close-channel-sdk-binary-ios/archive/refs/tags/1.7.0.zip",
            checksum: "57490cd71dfb69c738037829c9ae23d6742b01771c9d5f6473b1b68f9f4b75e4"
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
