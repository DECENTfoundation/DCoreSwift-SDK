import Foundation
import BigInt

public struct NftTransferOperation: Operation {
    
    public var from: ChainObject {
        willSet { precondition(from.objectType == .accountObject, "not a valid account object id") }
    }
    public var to: ChainObject {
        willSet { precondition(to.objectType == .accountObject, "not a valid account object id") }
    }
    public var nftDataId: ChainObject {
        willSet { precondition(nftDataId.objectType == .nftDataObject, "not a valid nft data object id") }
    }
    public var memo: Memo?
    
    public let type: OperationType = .nftTransfer
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        to,
        nftDataId = "nft_data_id",
        memo,
        fee
    }
}

extension NftTransferOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> NftTransferOperation {
        var op = self
        op.memo = try memo?.decrypt(keyPair, address: address, nonce: nonce)
        
        return op
    }
}

extension NftTransferOperation {
    public func asData() -> Data {
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += from.asData()
        data += to.asData()
        data += nftDataId.asData()
        data += memo.asOptionalData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "NftTransferOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
