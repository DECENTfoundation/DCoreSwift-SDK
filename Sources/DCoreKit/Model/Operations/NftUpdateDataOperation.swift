import Foundation
import BigInt

public struct NftUpdateDataOperation: Operation {
    
    public var modifier: ChainObject {
        willSet { precondition(modifier.objectType == .accountObject, "not a valid account object id") }
    }
    public var nftDataId: ChainObject {
        willSet { precondition(nftDataId.objectType == .nftDataObject, "not a valid nft data object id") }
    }
    public var data: [Pair<String, AnyValue>] {
        willSet {
            precondition(
                !data.isEmpty && data.allSatisfy { !$0.first.isEmpty }, "data cannot be empty or have empty keys"
            )
        }
    }
    
    public let type: OperationType = .nftUpdateData
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        modifier,
        nftDataId = "nft_data_id",
        data,
        fee
    }
}

extension NftUpdateDataOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> NftUpdateDataOperation {
        return self
    }
}

extension NftUpdateDataOperation {
    public func asData() -> Data {
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += modifier.asData()
        data += nftDataId.asData()
        data += self.data.asData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "NftUpdateDataOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
