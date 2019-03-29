
DCoreKit: DCore SDK for Swift
======================================

Set of APIs for accessing the DCore Blockchain.


## Requirements

* Xcode 10.0+
* Swift 4.0+
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
git "git@bitbucket.org:DECENTGroup/dcoreswift-sdk.git" ~> 2.0.0
```

and then use

```bash
$ carthage update --platform iOS
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

## References

* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [Secp256k1](https://github.com/bitcoin-core/secp256k1.git)
* [Openssl](https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz)