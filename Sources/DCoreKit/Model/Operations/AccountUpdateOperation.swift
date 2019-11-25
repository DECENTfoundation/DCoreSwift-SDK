import Foundation
import BigInt

public struct AccountUpdateOperation: Operation {
    
    public let accountId: AccountObjectId
    public let owner: Authority?
    public let active: Authority?
    public let options: Options?
    
    public let type: OperationType = .accountUpdateOperation
    public var fee: AssetAmount  = .unset

    public init(
        _ account: Account,
        active: Authority? = nil,
        owner: Authority? = nil,
        options: Options? = nil,
        fee: AssetAmount = .unset) {
        accountId = account.id
        self.options = options
        self.active = active
        self.owner = owner
        self.fee = fee
    }
    
    public init(
        _ account: Account,
        active: Authority? = nil,
        owner: Authority? = nil,
        votes: Set<VoteId> = [],
        fee: AssetAmount = .unset) {
        accountId = account.id
        options = account.options.apply(votes: votes)
        self.active = active
        self.owner = owner
        self.fee = fee
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
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AccountUpdateOperation {
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
