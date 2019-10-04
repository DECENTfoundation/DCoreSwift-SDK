import Foundation
import BigInt

public struct AssetClaimFeesOperation: Operation {
    
    public var issuer: ChainObject {
        willSet { precondition(issuer.objectType == .accountObject, "not a valid account object id") }
    }
    public var uiaAsset: AssetAmount
    public var dctAsset: AssetAmount
    
    public let type: OperationType = .assetClaimFeesOperation
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        issuer,
        uiaAsset = "uia_asset",
        dctAsset = "dct_asset",
        fee
    }
}

extension AssetClaimFeesOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AssetClaimFeesOperation {
        return self
    }
}

extension AssetClaimFeesOperation {
    public func asData() -> Data {
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += issuer.asData()
        data += uiaAsset.asData()
        data += dctAsset.asData()
        
        DCore.Logger.debug(crypto: "AssetClaimFeesOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
