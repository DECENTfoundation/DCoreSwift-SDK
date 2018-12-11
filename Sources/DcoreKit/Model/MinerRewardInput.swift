import Foundation
import BigInt

public struct MinerRewardInput {
    
    public let timeToMaintenance: UInt64
    public let fromAccumulatedFees: BigInt
    public let blockInterval: UInt16
    
    private enum CodingKeys: String, CodingKey {
        case
        timeToMaintenance = "time_to_maint",
        fromAccumulatedFees = "from_accumulated_fees",
        blockInterval = "block_interval"
    }
}
