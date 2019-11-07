import Foundation

public struct GlobalProperties: Codable {
    public let id: GlobalPropertyObjectId
    public let parameters: GlobalParameters
    public let nextAvailableVoteId: UInt64
    public let activeMiners: [MinerObjectId]
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        parameters,
        nextAvailableVoteId = "next_available_vote_id",
        activeMiners = "active_miners"
    }
}
