import Foundation
import BigInt

public struct NftIssueOperation: Operation {
    
    public var issuer: AccountObjectId
    public var nftId: NftObjectId
    public var to: AccountObjectId
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
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += issuer.asData()
        data += to.asData()
        data += nftId.asData()
        data += self.data.asData()
        data += memo.asOptionalData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "NftIssueOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
