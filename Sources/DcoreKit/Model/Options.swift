import Foundation

public struct Options: Codable {
    public let memoKey: Address
    public let votingAccount: ChainObject
    public let numMiner: UInt16
    public let votes: Set<VoteId>
    public var extensions: AnyValue?
    public let allowSubscription: Bool
    public let pricePerSubscribe: AssetAmount
    public let subscriptionPeriod: Int
    
    private enum CodingKeys: String, CodingKey {
        case
        memoKey = "memo_key",
        votingAccount = "voting_account",
        numMiner = "num_miner",
        votes,
        extensions,
        allowSubscription = "allow_subscription",
        pricePerSubscribe = "price_per_subscribe",
        subscriptionPeriod = "subscription_period"
    }
    
    public init(usingPublic address: Address) {
        memoKey = address
        votingAccount = "1.2.3".chainObject
        numMiner = 0
        votes = Set<VoteId>()
        extensions = .array([])
        allowSubscription = false
        pricePerSubscribe = AssetAmount(amount:0)
        subscriptionPeriod = 0
    }
}


extension Options: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += memoKey
        data += votingAccount
        data += numMiner
        data += votes
        data += Data(count: 1)
        data += allowSubscription
        data += pricePerSubscribe
        data += subscriptionPeriod
        return data
    }
}
