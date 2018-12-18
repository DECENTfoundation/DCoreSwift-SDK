import Foundation
import BigInt

public struct AccountStatistics: Codable {
    public let id: ChainObject
    public let owner: ChainObject
    public let mostRecentOp: ChainObject
    public let totalOps: UInt64
    public let totalCoreInOrders: BigInt
    public let pendingFees: BigInt
    public let pendingVestedFees: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        owner,
        mostRecentOp = "most_recent_op",
        totalOps = "total_ops",
        totalCoreInOrders = "total_core_in_orders",
        pendingFees = "pending_fees",
        pendingVestedFees = "pending_vested_fees"
    }
}
