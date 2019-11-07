import Foundation
import BigInt

public struct Miner: Codable {
    
    public let id: MinerObjectId
    public let minerAccount: AccountObjectId
    public let lastAslot: Int
    public let signingKey: Address
    public let payVb: VestingBalanceObjectId
    public let voteId: String
    public let totalVotes: BigInt
    public let url: String
    public let totalMissed: Int
    public let lastConfirmedBlockNum: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        minerAccount = "miner_account",
        lastAslot = "last_aslot",
        signingKey = "signing_key",
        payVb = "pay_vb",
        voteId = "vote_id",
        totalVotes = "total_votes",
        url,
        totalMissed = "total_missed",
        lastConfirmedBlockNum = "last_confirmed_block_num"
    }
}
