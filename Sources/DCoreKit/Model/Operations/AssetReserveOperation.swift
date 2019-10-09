import Foundation
import BigInt

public struct AssetReserveOperation: Operation {
    
    public var payer: ChainObject {
        willSet { precondition(payer.objectType == .accountObject, "not a valid account object id") }
    }
    public var amountToReserve: AssetAmount
    
    public let type: OperationType = .assetReserveOperation
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        payer,
        amountToReserve = "amount_to_reserve",
        fee
    }
}

extension AssetReserveOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AssetReserveOperation {
        return self
    }
}

extension AssetReserveOperation {
    public func asData() -> Data {
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += payer.asData()
        data += amountToReserve.asData()
        
        DCore.Logger.debug(crypto: "AssetReserveOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
