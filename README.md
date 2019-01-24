
DCoreKit: DCore SDK for Swift
======================================

Set of APIs for accessing the DCore Blockchain.


## Requirements

* Xcode 10.0+
* Swift 4.0+
* automake & libtool (for building library dependecies - openssl, secp256k1)

### Installation

Use `homebrew` for OSX to install prerequisites

```bash
$ brew install automake
$ brew install libtool
```

or on Linux

```bash
$ apt-get install automake
$ apt-get install libtool
```


### [Carthage](https://github.com/Carthage/Carthage)

**Tested with `carthage version`: `0.31.2`**

Add this to `Cartfile`

```
git "git@bitbucket.org:DECENTGroup/dcoreswift-sdk.git" ~> 0.2.1
```

and then use

```bash
$ carthage update
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

**Tested with `swift build --version`: `Swift 4.2.0 (swiftpm-14460.2)`**

Create a `Package.swift` file.

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "DCoreProject",
  dependencies: [
    .package(url: "https://bitbucket.org/DECENTGroup/dcoreswift-sdk.git", .from("0.2.1"))
  ],
  targets: [
    .target(name: "DCoreProject", dependencies: ["DCoreKit"])
  ]
)
```

```bash
$ swift build
```

To test a module with DCoreKitTest

```bash
$ swift test
```

## Usage

Access api using rest

```swift
import DCoreKit

let api = DCore.Sdk.create(forRest: "https://stagesocket.decentgo.com:8090/rpc")
let disposable = api.account.getAccount(byName: "u961279ec8b7ae7bd62f304f7c1c3d345").subscribe { 
	account in

	print(account.id) 
}
```

Access api using socket

```swift
import DCoreKit

let creds = try? Credentials("1.2.17".chain.chainObject!, wif: "....pk....")
let api = DCore.Sdk.create(forWss: "wss://stagesocket.decentgo.com:8090")
let disposable = api.operation.transfer(creds!, to: "1.2.34", amount: AssetAmount(1000000)).subscribe { 
	confirmation in

	print(confirmation.blockNum) 
}
```

## References

* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [Secp256k1](https://github.com/bitcoin-core/secp256k1.git)
* [Openssl](https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz)