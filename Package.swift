// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DCoreKit",
    products: [
        .library(name: "DCoreKit", targets: ["DCoreKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "0.13.0")),
        .package(url: "https://github.com/fl3xman/BigInt", .branch("master")),
        .package(url: "https://github.com/daltoniam/starscream", from: "3.0.6"),
        .package(url: "https://github.com/vapor-community/copenssl.git", .exact("1.0.0-rc.1")),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "DCoreKit", dependencies: ["RxSwift", "CryptoSwift", "BigInt", "Starscream", "COpenSSL", "secp256k1", "SwiftyJSON"]),
        .testTarget(name: "DCoreKitTests", dependencies: ["DCoreKit", "RxTest", "RxBlocking"]),
    ],
    swiftLanguageVersions: [4]
)
