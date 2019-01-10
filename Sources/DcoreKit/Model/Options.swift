import Foundation

public struct Options: Codable {
    
    public let memoKey: Address
    public let votingAccount: ChainObject
    public let numMiner: UInt16
    public let votes: [VoteId]
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
    
    public init(fromAddress address: Address) {
        memoKey = address
        votingAccount = "1.2.3".chain.chainObject!
        numMiner = 0
        votes = []
        extensions = .array([])
        allowSubscription = false
        pricePerSubscribe = AssetAmount(0)
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
