import Foundation
import BigInt

public struct AssetFundPoolsOperation: Operation {
    
    public var fromAccount: ChainObject {
        willSet { precondition(fromAccount.objectType == .accountObject, "not a valid account object id") }
    }
    public var uiaAsset: AssetAmount
    public var dctAsset: AssetAmount
    
    public let type: OperationType = .assetFundPoolsOperation
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        fromAccount = "from_account",
        uiaAsset = "uia_asset",
        dctAsset = "dct_asset",
        fee
    }
}

extension AssetFundPoolsOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AssetFundPoolsOperation {
        return self
    }
}

extension AssetFundPoolsOperation {
    public func asData() -> Data {
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += fromAccount.asData()
        data += uiaAsset.asData()
        data += dctAsset.asData()
        
        DCore.Logger.debug(crypto: "AssetFundPoolsOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
