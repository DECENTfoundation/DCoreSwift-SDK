import Foundation
import BigInt

public struct DynamicGlobalProps: Codable {
    
    public let id: DynamicGlobalPropertyObjectId
    public let headBlockNumber: UInt64
    public let headBlockId: String
    public let time: Date
    public let currentMiner: MinerObjectId
    public let nextMaintenanceTime: Date
    public let lastBudgetTime: Date
    public let unspentFeeBudget: BigInt
    public let minedRewards: BigInt
    public let minerBudgetFromFees: BigInt
    public let minerBudgetFromRewards: BigInt
    public let accountsRegisteredThisInterval: UInt64
    public let recentlyMissedCount: UInt64
    public let currentAslot: UInt64
    public let recentSlotsFilled: String
    public let dynamicFlags: Int
    public let lastIrreversibleBlockNum: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        headBlockNumber = "head_block_number",
        headBlockId = "head_block_id",
        time,
        currentMiner = "current_miner",
        nextMaintenanceTime = "next_maintenance_time",
        lastBudgetTime = "last_budget_time",
        unspentFeeBudget = "unspent_fee_budget",
        minedRewards = "mined_rewards",
        minerBudgetFromFees = "miner_budget_from_fees",
        minerBudgetFromRewards = "miner_budget_from_rewards",
        accountsRegisteredThisInterval = "accounts_registered_this_interval",
        recentlyMissedCount = "recently_missed_count",
        currentAslot = "current_aslot",
        recentSlotsFilled = "recent_slots_filled",
        dynamicFlags = "dynamic_flags",
        lastIrreversibleBlockNum = "last_irreversible_block_num"
    }
}
