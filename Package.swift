// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DcoreKit",
    products: [
        .library(name: "DcoreKit", targets: ["DcoreKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "0.8.0"))
    ],
    targets: [
        .target(name: "DcoreKit", dependencies: ["RxSwift", "CryptoSwift"]),
        .testTarget(name: "DcoreKitTests", dependencies: ["DcoreKit"]),
    ]
)
