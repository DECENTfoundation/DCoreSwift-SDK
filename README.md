
DCore SDK for Swift
======================================

Set of APIs for accessing the DCore Blockchain. <br>
If you are looking for other platforms you can find info [below](#official-dcore-sdks-for-other-platforms).


## Requirements

* Xcode 10.0 - 10.1 (10.2 is unsupported)
* Swift 4.0 - 4.2 (5.0 is unsupported)
* automake & libtool (for building library dependecies - openssl, secp256k1)

### Supported Platforms

* iOS 10.0+

### Installation

Use `homebrew` for OSX to install prerequisites

```bash
$ brew install automake
$ brew install libtool
```

### [Carthage](https://github.com/Carthage/Carthage)

**Tested with `carthage version`: `0.31.2`**

Add this to `Cartfile`

```
github "DECENTfoundation/DCoreSwift-SDK" ~> 2.2.0
```

and then use

```bash
$ carthage update --platform iOS --no-use-binaries
```

## Usage

Access api using rest (Get an account object)

```swift
import DCoreKit

let api = DCore.Sdk.create(forRest: "https://testnet-api.dcore.io/rpc")
let disposable = api.account.get(byName: "public-account-2").subscribe { 
	account in

	print(account.id) 
}
```

Access api using socket (Transfer amount between accounts)

```swift
import DCoreKit

let creds = try? Credentials("1.2.19".chain.chainObject!, wif: "5KfatbpE1zVdnHgFydT7Cg9hJmUVLN7vQXJkBbzGrNSND3uFmAa")
let api = DCore.Sdk.create(forWss: "wss://testnet-api.dcore.io")
let disposable = api.account.transfer(from: creds!, to: "1.2.20", amount: AssetAmount(1000000)).subscribe { 
	confirmation in

	print(confirmation.blockNum) 
}
```

## Official DCore SDKs for other platforms

- [Android/Java/Kotlin](https://github.com/DECENTfoundation/DCoreKt-SDK)
- [JavaScript/TypeScript/Node.js](https://github.com/DECENTfoundation/DCoreJS-SDK)
- [PHP](https://github.com/DECENTfoundation/DCorePHP-SDK)


## References

* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [Secp256k1](https://github.com/bitcoin-core/secp256k1.git)
* [Openssl](https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz)