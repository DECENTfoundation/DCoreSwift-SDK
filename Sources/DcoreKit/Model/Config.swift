import Foundation
import BigInt

public struct Config: Codable {
    public let grapheneSymbol: String
    public let grapheneAddressPrefix: String
    public let grapheneMinAccountNameLength: Int
    public let grapheneMaxAccountNameLength: Int
    public let grapheneMinAssetSymbolLength: Int
    public let grapheneMaxAssetSymbolLength: Int
    public let grapheneMaxShareSupply: UInt64
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
        grapheneSymbol = "GRAPHENE_SYMBOL",
        grapheneAddressPrefix = "GRAPHENE_ADDRESS_PREFIX",
        grapheneMinAccountNameLength = "GRAPHENE_MIN_ACCOUNT_NAME_LENGTH",
        grapheneMaxAccountNameLength = "GRAPHENE_MAX_ACCOUNT_NAME_LENGTH",
        grapheneMinAssetSymbolLength = "GRAPHENE_MIN_ASSET_SYMBOL_LENGTH",
        grapheneMaxAssetSymbolLength = "GRAPHENE_MAX_ASSET_SYMBOL_LENGTH",
        grapheneMaxShareSupply = "GRAPHENE_MAX_SHARE_SUPPLY",
        grapheneMaxPayRate = "GRAPHENE_MAX_PAY_RATE",
        grapheneMaxSigCheckDepth = "GRAPHENE_MAX_SIG_CHECK_DEPTH",
        grapheneMinTransactionSizeLimit = "GRAPHENE_MIN_TRANSACTION_SIZE_LIMIT",
        grapheneMinBlockInterval = "GRAPHENE_MIN_BLOCK_INTERVAL",
        grapheneMaxBlockInterval = "GRAPHENE_MAX_BLOCK_INTERVAL",
        grapheneDefaultBlockInterval = "GRAPHENE_DEFAULT_BLOCK_INTERVAL",
        grapheneDefaultMaxTransactionSize = "GRAPHENE_DEFAULT_MAX_TRANSACTION_SIZE",
        grapheneDefaultMaxBlockSize = "GRAPHENE_DEFAULT_MAX_BLOCK_SIZE",
        grapheneDefaultMaxTimeUntilExpiration = "GRAPHENE_DEFAULT_MAX_TIME_UNTIL_EXPIRATION",
        grapheneDefaultMaintenanceInterval = "GRAPHENE_DEFAULT_MAINTENANCE_INTERVAL",
        grapheneDefaultMaintenanceSkipSlots = "GRAPHENE_DEFAULT_MAINTENANCE_SKIP_SLOTS",
        grapheneMinUndoHistory = "GRAPHENE_MIN_UNDO_HISTORY",
        grapheneMaxUndoHistory = "GRAPHENE_MAX_UNDO_HISTORY",
        grapheneMinBlockSizeLimit = "GRAPHENE_MIN_BLOCK_SIZE_LIMIT",
        grapheneMinTransactionExpirationLimit = "GRAPHENE_MIN_TRANSACTION_EXPIRATION_LIMIT",
        grapheneBlockchainPrecision = "GRAPHENE_BLOCKCHAIN_PRECISION",
        grapheneBlockchainPrecisionDigits = "GRAPHENE_BLOCKCHAIN_PRECISION_DIGITS",
        grapheneDefaultTransferFee = "GRAPHENE_DEFAULT_TRANSFER_FEE",
        grapheneMaxInstanceId = "GRAPHENE_MAX_INSTANCE_ID",
        graphene100Percent = "GRAPHENE_100_PERCENT",
        graphene1Percent = "GRAPHENE_1_PERCENT",
        grapheneMaxMarketFeePercent = "GRAPHENE_MAX_MARKET_FEE_PERCENT",
        grapheneDefaultForceSettlementDelay = "GRAPHENE_DEFAULT_FORCE_SETTLEMENT_DELAY",
        grapheneDefaultForceSettlementOffset = "GRAPHENE_DEFAULT_FORCE_SETTLEMENT_OFFSET",
        grapheneDefaultForceSettlementMaxVolume = "GRAPHENE_DEFAULT_FORCE_SETTLEMENT_MAX_VOLUME",
        grapheneDefaultPriceFeedLifetime = "GRAPHENE_DEFAULT_PRICE_FEED_LIFETIME",
        grapheneMaxFeedProducers = "GRAPHENE_MAX_FEED_PRODUCERS",
        grapheneDefaultMaxAuthorityMembership = "GRAPHENE_DEFAULT_MAX_AUTHORITY_MEMBERSHIP",
        grapheneDefaultMaxAssetWhitelistAuthorities = "GRAPHENE_DEFAULT_MAX_ASSET_WHITELIST_AUTHORITIES",
        grapheneDefaultMaxAssetFeedPublishers = "GRAPHENE_DEFAULT_MAX_ASSET_FEED_PUBLISHERS",
        grapheneCollateralRatioDenom = "GRAPHENE_COLLATERAL_RATIO_DENOM",
        grapheneMinCollateralRatio = "GRAPHENE_MIN_COLLATERAL_RATIO",
        grapheneMaxCollateralRatio = "GRAPHENE_MAX_COLLATERAL_RATIO",
        grapheneDefaultMaintenanceCollateralRatio = "GRAPHENE_DEFAULT_MAINTENANCE_COLLATERAL_RATIO",
        grapheneDefaultMaxShortSqueezeRatio = "GRAPHENE_DEFAULT_MAX_SHORT_SQUEEZE_RATIO",
        grapheneDefaultMarginPeriodSec = "GRAPHENE_DEFAULT_MARGIN_PERIOD_SEC",
        grapheneDefaultMaxMiners = "GRAPHENE_DEFAULT_MAX_MINERS",
        grapheneDefaultMaxProposalLifetimeSec = "GRAPHENE_DEFAULT_MAX_PROPOSAL_LIFETIME_SEC",
        grapheneDefaultMinerProposalReviewPeriodSec = "GRAPHENE_DEFAULT_MINER_PROPOSAL_REVIEW_PERIOD_SEC",
        grapheneDefaultNetworkPercentOfFee = "GRAPHENE_DEFAULT_NETWORK_PERCENT_OF_FEE",
        grapheneDefaultLifetimeReferrerPercentOfFee = "GRAPHENE_DEFAULT_LIFETIME_REFERRER_PERCENT_OF_FEE",
        grapheneDefaultMaxBulkDiscountPercent = "GRAPHENE_DEFAULT_MAX_BULK_DISCOUNT_PERCENT",
        grapheneDefaultBulkDiscountThresholdMin = "GRAPHENE_DEFAULT_BULK_DISCOUNT_THRESHOLD_MIN",
        grapheneDefaultBulkDiscountThresholdMax = "GRAPHENE_DEFAULT_BULK_DISCOUNT_THRESHOLD_MAX",
        grapheneDefaultCashbackVestingPeriodSec = "GRAPHENE_DEFAULT_CASHBACK_VESTING_PERIOD_SEC",
        grapheneDefaultCashbackVestingThreshold = "GRAPHENE_DEFAULT_CASHBACK_VESTING_THRESHOLD",
        grapheneDefaultBurnPercentOfFee = "GRAPHENE_DEFAULT_BURN_PERCENT_OF_FEE",
        grapheneMinerPayPercentPrecision = "GRAPHENE_MINER_PAY_PERCENT_PRECISION",
        grapheneDefaultMaxAssertOpcode = "GRAPHENE_DEFAULT_MAX_ASSERT_OPCODE",
        grapheneDefaultFeeLiquidationThreshold = "GRAPHENE_DEFAULT_FEE_LIQUIDATION_THRESHOLD",
        grapheneDefaultAccountsPerFeeScale = "GRAPHENE_DEFAULT_ACCOUNTS_PER_FEE_SCALE",
        grapheneDefaultAccountFeeScaleBitshifts = "GRAPHENE_DEFAULT_ACCOUNT_FEE_SCALE_BITSHIFTS",
        grapheneMaxWorkerNameLength = "GRAPHENE_MAX_WORKER_NAME_LENGTH",
        grapheneMaxUrlLength = "GRAPHENE_MAX_URL_LENGTH",
        grapheneNearScheduleCtrIv = "GRAPHENE_NEAR_SCHEDULE_CTR_IV",
        grapheneFarScheduleCtrIv = "GRAPHENE_FAR_SCHEDULE_CTR_IV",
        grapheneCoreAssetCycleRate = "GRAPHENE_CORE_ASSET_CYCLE_RATE",
        grapheneCoreAssetCycleRateBits = "GRAPHENE_CORE_ASSET_CYCLE_RATE_BITS",
        grapheneDefaultMinerPayPerBlock = "GRAPHENE_DEFAULT_MINER_PAY_PER_BLOCK",
        grapheneDefaultMinerPayVestingSeconds = "GRAPHENE_DEFAULT_MINER_PAY_VESTING_SECONDS",
        grapheneMaxInterestApr = "GRAPHENE_MAX_INTEREST_APR",
        grapheneMinerAccount = "GRAPHENE_MINER_ACCOUNT",
        grapheneNullAccount = "GRAPHENE_NULL_ACCOUNT",
        grapheneTempAccount = "GRAPHENE_TEMP_ACCOUNT"
    }
}
