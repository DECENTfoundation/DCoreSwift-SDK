import Foundation
import BigInt

public struct AssetUpdateAdvancedOperation: Operation {
    
    public var issuer: ChainObject {
        willSet { precondition(issuer.objectType == .accountObject, "not a valid account object id") }
    }
    public var assetToUpdate: ChainObject {
        willSet { precondition(assetToUpdate.objectType == .assetObject, "not a valid asset object id") }
    }
    public var precision: UInt8 {
        willSet {
            precondition(
                (0...DCore.Constant.maxAssetPrecision).contains(Int(precision)),
                "precision must be in range of 0-\(DCore.Constant.maxAssetPrecision)"
            )
        }
    }
    public var fixedMaxSupply: Bool
    
    public let type: OperationType = .updateUserIssuedAssetAdvancedOperation
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        issuer,
        assetToUpdate = "asset_to_update",
        precision = "new_precision",
        fixedMaxSupply = "set_fixed_max_supply",
        fee
    }
}

extension AssetUpdateAdvancedOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AssetUpdateAdvancedOperation {
        return self
    }
}

extension AssetUpdateAdvancedOperation {
    public func asData() -> Data {
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += issuer.asData()
        data += assetToUpdate.asData()
        data += precision
        data += fixedMaxSupply.asData()
        
        DCore.Logger.debug(crypto: "AssetUpdateAdvancedOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
