import Foundation
import BigInt

public struct AssetIssueOperation: Operation {
    
    public var issuer: ChainObject {
        willSet { precondition(issuer.objectType == .accountObject, "not a valid account object id") }
    }
    public var assetToIssue: AssetAmount
    public var issueToAccount: ChainObject {
        willSet { precondition(issueToAccount.objectType == .accountObject, "not a valid account object id") }
    }
    public var memo: Memo?
    
    public let type: OperationType = .assetIssueOperation
    public var fee: AssetAmount  = .unset
    
    private enum CodingKeys: String, CodingKey {
        case
        issuer,
        assetToIssue = "asset_to_issue",
        issueToAccount = "issue_to_account",
        memo,
        fee
    }
}

extension AssetIssueOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AssetIssueOperation {
        var op = self
        op.memo = try memo?.decrypt(keyPair, address: address, nonce: nonce)
        
        return op
    }
}

extension AssetIssueOperation {
    public func asData() -> Data {
        // TODO: Test and fix this method if necessary
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += issuer.asData()
        data += assetToIssue.asData()
        data += issueToAccount.asData()
        data += memo.asData()
        
        DCore.Logger.debug(crypto: "AssetIssueOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
