import Foundation
import BigInt

public struct Config: Codable {

    public let grapheneSymbol: String
    public let grapheneAddressPrefix: String
    public let grapheneMinAccountNameLength: Int
    public let grapheneMaxAccountNameLength: Int
    public let grapheneMinAssetSymbolLength: Int
    public let grapheneMaxAssetSymbolLength: Int
    public let grapheneMaxShareSupply: BigInt
    public let grapheneMaxPayRate: Int
    public let grapheneMaxSigCheckDepth: Int
    public let grapheneMinTransactionSizeLimit: Int
    public let grapheneMinBlockInterval: Int
    public let grapheneMaxBlockInterval: Int
    public let grapheneDefaultBlockInterval: Int
    public let grapheneDefaultMaxTransactionSize: Int
    public let grapheneDefaultMaxBlockSize: Int
    public let grapheneDefaultMaxTimeUntilExpiration: Int
    public let grapheneDefaultMaintenanceInterval: Int
    public let grapheneDefaultMaintenanceSkipSlots: Int
    public let grapheneMinUndoHistory: Int
    public let grapheneMaxUndoHistory: Int
    public let grapheneMinBlockSizeLimit: Int
    public let grapheneMinTransactionExpirationLimit: Int
    public let grapheneBlockchainPrecision: Int
    public let grapheneBlockchainPrecisionDigits: Int
    public let grapheneDefaultTransferFee: Int
    public let grapheneMaxInstanceId: BigInt
    public let graphene100Percent: Int
    public let graphene1Percent: Int
    public let grapheneMaxMarketFeePercent: Int
    public let grapheneDefaultForceSettlementDelay: Int
    public let grapheneDefaultForceSettlementOffset: Int
    public let grapheneDefaultForceSettlementMaxVolume: Int
    public let grapheneDefaultPriceFeedLifetime: Int
    public let grapheneMaxFeedProducers: Int
    public let grapheneDefaultMaxAuthorityMembership: Int
    public let grapheneDefaultMaxAssetWhitelistAuthorities: Int
    public let grapheneDefaultMaxAssetFeedPublishers: Int
    public let grapheneCollateralRatioDenom: Int
    public let grapheneMinCollateralRatio: Int
    public let grapheneMaxCollateralRatio: Int
    public let grapheneDefaultMaintenanceCollateralRatio: Int
    public let grapheneDefaultMaxShortSqueezeRatio: Int
    public let grapheneDefaultMarginPeriodSec: Int
    public let grapheneDefaultMaxMiners: Int
    public let grapheneDefaultMaxProposalLifetimeSec: Int
    public let grapheneDefaultMinerProposalReviewPeriodSec: Int
    public let grapheneDefaultNetworkPercentOfFee: Int
    public let grapheneDefaultLifetimeReferrerPercentOfFee: Int
    public let grapheneDefaultMaxBulkDiscountPercent: Int
    public let grapheneDefaultBulkDiscountThresholdMin: BigInt
    public let grapheneDefaultBulkDiscountThresholdMax: BigInt
    public let grapheneDefaultCashbackVestingPeriodSec: Int
    public let grapheneDefaultCashbackVestingThreshold: BigInt
    public let grapheneDefaultBurnPercentOfFee: Int
    public let grapheneMinerPayPercentPrecision: Int
    public let grapheneDefaultMaxAssertOpcode: Int
    public let grapheneDefaultFeeLiquidationThreshold: Int
    public let grapheneDefaultAccountsPerFeeScale: Int
    public let grapheneDefaultAccountFeeScaleBitshifts: Int
    public let grapheneMaxWorkerNameLength: Int
    public let grapheneMaxUrlLength: Int
    public let grapheneNearScheduleCtrIv: BigInt
    public let grapheneFarScheduleCtrIv: BigInt
    public let grapheneCoreAssetCycleRate: Int
    public let grapheneCoreAssetCycleRateBits: Int
    public let grapheneDefaultMinerPayPerBlock: Int
    public let grapheneDefaultMinerPayVestingSeconds: Int
    public let grapheneMaxInterestApr: Int
    public let grapheneMinerAccount: ChainObject
    public let grapheneNullAccount: ChainObject
    public let grapheneTempAccount: ChainObject
    
    private enum CodingKeys: String, CodingKey {
        case
        grapheneSymbol  = "graphene_symbol",
        grapheneAddressPrefix  = "graphene_address_prefix",
        grapheneMinAccountNameLength  = "graphene_min_account_name_length",
        grapheneMaxAccountNameLength  = "graphene_max_account_name_length",
        grapheneMinAssetSymbolLength  = "graphene_min_asset_symbol_length",
        grapheneMaxAssetSymbolLength  = "graphene_max_asset_symbol_length",
        grapheneMaxShareSupply  = "graphene_max_share_supply",
        grapheneMaxPayRate  = "graphene_max_pay_rate",
        grapheneMaxSigCheckDepth  = "graphene_max_sig_check_depth",
        grapheneMinTransactionSizeLimit  = "graphene_min_transaction_size_limit",
        grapheneMinBlockInterval  = "graphene_min_block_interval",
        grapheneMaxBlockInterval  = "graphene_max_block_interval",
        grapheneDefaultBlockInterval  = "graphene_default_block_interval",
        grapheneDefaultMaxTransactionSize  = "graphene_default_max_transaction_size",
        grapheneDefaultMaxBlockSize  = "graphene_default_max_block_size",
        grapheneDefaultMaxTimeUntilExpiration  = "graphene_default_max_time_until_expiration",
        grapheneDefaultMaintenanceInterval  = "graphene_default_maintenance_interval",
        grapheneDefaultMaintenanceSkipSlots  = "graphene_default_maintenance_skip_slots",
        grapheneMinUndoHistory  = "graphene_min_undo_history",
        grapheneMaxUndoHistory  = "graphene_max_undo_history",
        grapheneMinBlockSizeLimit  = "graphene_min_block_size_limit",
        grapheneMinTransactionExpirationLimit  = "graphene_min_transaction_expiration_limit",
        grapheneBlockchainPrecision  = "graphene_blockchain_precision",
        grapheneBlockchainPrecisionDigits  = "graphene_blockchain_precision_digits",
        grapheneDefaultTransferFee  = "graphene_default_transfer_fee",
        grapheneMaxInstanceId  = "graphene_max_instance_id",
        graphene100Percent  = "graphene_100_percent",
        graphene1Percent  = "graphene_1_percent",
        grapheneMaxMarketFeePercent  = "graphene_max_market_fee_percent",
        grapheneDefaultForceSettlementDelay  = "graphene_default_force_settlement_delay",
        grapheneDefaultForceSettlementOffset  = "graphene_default_force_settlement_offset",
        grapheneDefaultForceSettlementMaxVolume  = "graphene_default_force_settlement_max_volume",
        grapheneDefaultPriceFeedLifetime  = "graphene_default_price_feed_lifetime",
        grapheneMaxFeedProducers  = "graphene_max_feed_producers",
        grapheneDefaultMaxAuthorityMembership  = "graphene_default_max_authority_membership",
        grapheneDefaultMaxAssetWhitelistAuthorities  = "graphene_default_max_asset_whitelist_authorities",
        grapheneDefaultMaxAssetFeedPublishers  = "graphene_default_max_asset_feed_publishers",
        grapheneCollateralRatioDenom  = "graphene_collateral_ratio_denom",
        grapheneMinCollateralRatio  = "graphene_min_collateral_ratio",
        grapheneMaxCollateralRatio  = "graphene_max_collateral_ratio",
        grapheneDefaultMaintenanceCollateralRatio  = "graphene_default_maintenance_collateral_ratio",
        grapheneDefaultMaxShortSqueezeRatio  = "graphene_default_max_short_squeeze_ratio",
        grapheneDefaultMarginPeriodSec  = "graphene_default_margin_period_sec",
        grapheneDefaultMaxMiners  = "graphene_default_max_miners",
        grapheneDefaultMaxProposalLifetimeSec  = "graphene_default_max_proposal_lifetime_sec",
        grapheneDefaultMinerProposalReviewPeriodSec  = "graphene_default_miner_proposal_review_period_sec",
        grapheneDefaultNetworkPercentOfFee  = "graphene_default_network_percent_of_fee",
        grapheneDefaultLifetimeReferrerPercentOfFee  = "graphene_default_lifetime_referrer_percent_of_fee",
        grapheneDefaultMaxBulkDiscountPercent  = "graphene_default_max_bulk_discount_percent",
        grapheneDefaultBulkDiscountThresholdMin  = "graphene_default_bulk_discount_threshold_min",
        grapheneDefaultBulkDiscountThresholdMax  = "graphene_default_bulk_discount_threshold_max",
        grapheneDefaultCashbackVestingPeriodSec  = "graphene_default_cashback_vesting_period_sec",
        grapheneDefaultCashbackVestingThreshold  = "graphene_default_cashback_vesting_threshold",
        grapheneDefaultBurnPercentOfFee  = "graphene_default_burn_percent_of_fee",
        grapheneMinerPayPercentPrecision  = "graphene_miner_pay_percent_precision",
        grapheneDefaultMaxAssertOpcode  = "graphene_default_max_assert_opcode",
        grapheneDefaultFeeLiquidationThreshold  = "graphene_default_fee_liquidation_threshold",
        grapheneDefaultAccountsPerFeeScale  = "graphene_default_accounts_per_fee_scale",
        grapheneDefaultAccountFeeScaleBitshifts  = "graphene_default_account_fee_scale_bitshifts",
        grapheneMaxWorkerNameLength  = "graphene_max_worker_name_length",
        grapheneMaxUrlLength  = "graphene_max_url_length",
        grapheneNearScheduleCtrIv  = "graphene_near_schedule_ctr_iv",
        grapheneFarScheduleCtrIv  = "graphene_far_schedule_ctr_iv",
        grapheneCoreAssetCycleRate  = "graphene_core_asset_cycle_rate",
        grapheneCoreAssetCycleRateBits  = "graphene_core_asset_cycle_rate_bits",
        grapheneDefaultMinerPayPerBlock  = "graphene_default_miner_pay_per_block",
        grapheneDefaultMinerPayVestingSeconds  = "graphene_default_miner_pay_vesting_seconds",
        grapheneMaxInterestApr  = "graphene_max_interest_apr",
        grapheneMinerAccount  = "graphene_miner_account",
        grapheneNullAccount  = "graphene_null_account",
        grapheneTempAccount  = "graphene_temp_account"
    }
}
