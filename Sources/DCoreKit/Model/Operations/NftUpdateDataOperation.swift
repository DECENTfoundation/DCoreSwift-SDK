import Foundation
import BigInt

public struct NftUpdateDataOperation: Operation {
    
    public var modifier: ChainObject {
        willSet { precondition(modifier.objectType == .accountObject, "not a valid account object id") }
    }
    public var nftDataId: ChainObject {
        willSet { precondition(nftDataId.objectType == .nftDataObject, "not a valid nft data object id") }
    }
    public var data: [String: AnyValue] {
        willSet {
            precondition(
                !data.isEmpty && data.keys.allSatisfy { !$0.isEmpty }, "data cannot be empty or have empty keys"
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
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += modifier.asData()
        data += nftDataId.asData()
        data += UInt64(self.data.count).asUnsignedVarIntData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "NftUpdateDataOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
