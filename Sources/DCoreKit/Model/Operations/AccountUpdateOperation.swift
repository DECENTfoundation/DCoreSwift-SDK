import Foundation
import BigInt

public struct AccountUpdateOperation: Operation {
    
    public let accountId: ChainObject
    public var owner: Authority?
    public var active: Authority?
    public var options: Options?
    
    public let type: OperationType = .accountUpdateOperation
    public var fee: AssetAmount  = .unset
    
    public init(_ account: Account, votes: Set<VoteId>) {
        accountId = account.id
        options = account.options.apply(votes: votes)
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        accountId = "account",
        owner,
        active,
        options = "new_options",
        fee
    }
}

extension AccountUpdateOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address?, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AccountUpdateOperation {
        return self
    }
}

extension AccountUpdateOperation {
    public func asData() -> Data {
        
        var data = Data()
        data += type.asData()
        data += fee.asData()
        data += accountId.asData()
        data += owner.asOptionalData()
        data += active.asOptionalData()
        data += options.asOptionalData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "AccountUpdateOperation binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
