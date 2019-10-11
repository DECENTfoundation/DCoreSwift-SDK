import Foundation
import BigInt

public struct NftIssueOperation: Operation {
    
    public var issuer: ChainObject {
        willSet { precondition(issuer.objectType == .accountObject, "not a valid account object id") }
    }
    public var nftId: ChainObject {
        willSet { precondition(nftId.objectType == .nftObject, "not a valid nft object id") }
    }
    public var to: ChainObject {
        willSet { precondition(to.objectType == .accountObject, "not a valid account object id") }
    }
    public var data: [AnyValue]
    public var memo: Memo?
    
    public let type: OperationType = .nftIssue
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        issuer,
        nftId = "nft_id",
        to,
        data,
        memo,
        fee
    }
}

extension NftIssueOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> NftIssueOperation {
        var op = self
        op.memo = try memo?.decrypt(keyPair, address: address, nonce: nonce)
        
        return op
    }
}

extension NftIssueOperation {
    public func asData() -> Data {
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += issuer.asData()
        data += to.asData()
        data += nftId.asData()
        data += UInt64(self.data.count).asUnsignedVarIntData()
        data += memo.asOptionalData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "NftIssueOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
