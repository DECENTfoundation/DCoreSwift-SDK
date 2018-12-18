import Foundation
import BigInt

public struct MinerVotingInfo: Codable {
    public let id: ChainObject
    public let name: String
    public let url: String
    public let votes: BigInt
    public let voted: Bool
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        name,
        url,
        votes = "total_votes",
        voted
    }
}
