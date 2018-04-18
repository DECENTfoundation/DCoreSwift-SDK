// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DcoreKit",
    products: [
        .library(name: "DcoreKit", targets: ["DcoreKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "DcoreKit", dependencies: ["ReactiveSwift"]),
        .testTarget(name: "DcoreKitTests", dependencies: ["DcoreKit"]),
    ]
)
