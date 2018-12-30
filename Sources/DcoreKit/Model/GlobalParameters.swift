import Foundation
import BigInt

public struct GlobalParameters: Codable {
    
    public let fees: FeeSchedule
    public let blockInterval: UInt16
    public let maintenanceInterval: UInt64
    public let maintenanceSkipSlots: UInt16
    public let minerProposalReviewPeriod: UInt64
    public let maximumTransactionSize: UInt64
    public let maximumBlockSize: UInt64
    public let maximumTimeUntilExpiration: UInt64
    public let maximumProposalLifetime: UInt64
    public let maximumAssetFeedPublishers: UInt16
    public let maximumMinerCount: Int
    public let maximumAuthorityMembership: Int
    public let cashbackVestingPeriodSeconds: UInt64
    public let cashbackVestingThreshold: BigInt
    public let maxPredicateOpcode: Int
    public let maxAuthorityDepth: UInt16
    public let extensions: AnyValue?

    private enum CodingKeys: String, CodingKey {
        case
        fees = "current_fees",
        blockInterval = "block_interval",
        maintenanceInterval = "maintenance_interval",
        maintenanceSkipSlots = "maintenance_skip_slots",
        minerProposalReviewPeriod = "miner_proposal_review_period",
        maximumTransactionSize = "maximum_transaction_size",
        maximumBlockSize = "maximum_block_size",
        maximumTimeUntilExpiration = "maximum_time_until_expiration",
        maximumProposalLifetime = "maximum_proposal_lifetime",
        maximumAssetFeedPublishers = "maximum_asset_feed_publishers",
        maximumMinerCount = "maximum_miner_count",
        maximumAuthorityMembership = "maximum_authority_membership",
        cashbackVestingPeriodSeconds = "cashback_vesting_period_seconds",
        cashbackVestingThreshold = "cashback_vesting_threshold",
        maxPredicateOpcode = "max_predicate_opcode",
        maxAuthorityDepth = "max_authority_depth",
        extensions = "extensions"
    }
}
