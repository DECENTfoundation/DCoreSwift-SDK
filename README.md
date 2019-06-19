
DCore SDK for Swift
======================================

Set of APIs for accessing the DCore Blockchain. <br>
If you are looking for other platforms you can find info [below](#official-dcore-sdks-for-other-platforms).


## Requirements

* Xcode 10.2+
* Swift 5.0+ (from version 3.0.0+), Swift 4.2 (for versions 2.X.X)
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

**Tested with `carthage version`: `0.33.0`**

Add this to `Cartfile`

```
github "DECENTfoundation/DCoreSwift-SDK" ~> 3.0.0
```

and then use

```bash
$ carthage update --platform iOS
```

Link following frameworks from `Carthage/Build/iOS` folder to your app:
```
BigInt.framework
CryptoSwift.framework
DCoreKit.framework
RxSwift.framework
SipHash.framework
Starscream.framework
SwiftyJSON.framework
```

To link these frameworks to the app, please follow instructions specified in documentation of [Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)

Head over to your project's Build Settings and ensure your `Framework Search Paths` are set to: 
```
$(PROJECT_DIR)/Carthage/Build/iOS
```

## Usage

You can find **developer documentation** for latest release [here](https://decentfoundation.github.io/DCoreSwift-SDK/).

Access api using rest (Get an account object)

```swift
import DCoreKit

let api = DCore.Sdk.create(forRest: "https://testnet-api.dcore.io/rpc")
let disposable = api.account.get(byName: "public-account-2").subscribe(onSuccess: { 
	account in

	print(account.id) 
})
```

Access api using socket (Transfer amount between accounts)

```swift
import DCoreKit

let creds = try? Credentials("1.2.19".dcore.chainObject!, wif: "5KfatbpE1zVdnHgFydT7Cg9hJmUVLN7vQXJkBbzGrNSND3uFmAa")
let api = DCore.Sdk.create(forWss: "wss://testnet-api.dcore.io")
let disposable = api.account.transfer(from: creds!, to: "1.2.20", amount: AssetAmount(1000000)).subscribe(onSuccess: { 
	confirmation in

	print(confirmation.blockNum) 
})
```

## Official DCore SDKs for other platforms

- [Android/Java/Kotlin](https://github.com/DECENTfoundation/DCoreKt-SDK)
- [JavaScript/TypeScript/Node.js](https://github.com/DECENTfoundation/DCoreJS-SDK)
- [PHP](https://github.com/DECENTfoundation/DCorePHP-SDK)


## References

* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [Secp256k1](https://github.com/bitcoin-core/secp256k1.git)
* [Openssl](https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz)
