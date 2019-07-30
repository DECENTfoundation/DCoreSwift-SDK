import Foundation
import BigInt

public struct AssetCreateOperation: Operation {

    public var issuer: ChainObject {
        willSet { precondition(issuer.objectType == .accountObject, "not a valid account object id") }
    }
    public var symbol: String {
        willSet { precondition(Asset.hasValid(symbol: symbol), "invalid asset symbol: \(symbol)") }
    }
    public var precision: UInt8 {
        willSet {
            precondition(
                (0...DCore.Constant.maxAssetPrecision).contains(Int(precision)),
                "precision must be in range of 0-\(DCore.Constant.maxAssetPrecision)"
            )
        }
    }
    public var description: String {
        willSet {
            precondition(
                description.count <= DCore.Constant.uiaDescriptionMaxChars,
                "description cannot be longer then \(DCore.Constant.uiaDescriptionMaxChars) chars"
            )
        }
    }
    public var options: Asset.Options {
        willSet { precondition(options.maxSupply <= DCore.Constant.maxShareSupply, "max supply max value overflow") }
    }
    public var monitoredOptions: Asset.MonitoredAssetOptions?

    public let type: OperationType = .assetCreateOperation
    public var fee: AssetAmount  = .unset

    private enum CodingKeys: String, CodingKey {
        case
        issuer,
        symbol,
        precision,
        description,
        options,
        monitoredOptions = "monitored_asset_opts",
        fee
    }
}

extension AssetCreateOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AssetCreateOperation {
        return self
    }
}

extension AssetCreateOperation {
    public func asData() -> Data {
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += issuer.asData()
        data += symbol.asData()
        data += precision
        data += description.asData()
        data += options.asData()
        data += monitoredOptions.asOptionalData()
        data += true.asData()
        data += Data.ofZero

        DCore.Logger.debug(crypto: "AssetCreateOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
