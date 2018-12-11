import Foundation

public struct Options: Codable {
    
    public let memoKey: Address
    public let votingAccount: ChainObject
    public let numMiner: UInt16
    public let votes: Set<VoteId>
    public let extensions: [Any]
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
        votingAccount = "1.2.3".toChainObject()
        numMiner = 0
        votes = Set<VoteId>()
        extensions = [Any]()
        allowSubscription = false
        pricePerSubscribe = AssetAmount(amount:0)
        subscriptionPeriod = 0
    }
}


extension Options: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not implemented")
        
        /*
         get() = Bytes.concat(
         memoKey.bytes(),
         votingAccount.bytes,
         numMiner.bytes(),
         votes.bytes(),
         byteArrayOf(0),
         allowSubscription.bytes(),
         pricePerSubscribe.bytes,
         subscriptionPeriod.bytes()
         )
         */
    }
}
