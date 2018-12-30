import Foundation
import BigInt

public struct MinerVotes: Codable {
    
    public let account: String
    public let votes: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        account = "account_name",
        votes
    }
}
