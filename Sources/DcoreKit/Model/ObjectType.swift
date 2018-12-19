import Foundation

public enum ObjectType: UInt8, CaseIterable, Codable {
    
    public init(fromSpace space: Int, type: Int) {
        self = ObjectType.allCases[max(space - 1, 0) * 10 + type]
    }
    
    // dcore/libraries/chain/include/graphene/chain/protocol/types.hpp
    // enum object_type, space = 1
    case
    NULL_OBJECT = 0, // ordinal = 0, type = 0, space = any
    BASE_OBJECT,
    ACCOUNT_OBJECT,
    ASSET_OBJECT,
    MINER_OBJECT,
    CUSTOM_OBJECT, //5
    PROPOSAL_OBJECT,
    OPERATION_HISTORY_OBJECT,
    WITHDRAW_PERMISSION_OBJECT,
    VESTING_BALANCE_OBJECT,
    
    //  enum impl_object_type, space = 2
    GLOBAL_PROPERTY_OBJECT, // ordinal = 10, type 0
    DYNAMIC_GLOBAL_PROPERTY_OBJECT,
    RESERVED_OBJECT,
    ASSET_DYNAMIC_DATA,
    ACCOUNT_BALANCE_OBJECT,
    ACCOUNT_STATISTICS_OBJECT, //5
    TRANSACTION_OBJECT,
    BLOCK_SUMMARY_OBJECT,
    ACCOUNT_TRANSACTION_HISTORY_OBJECT,
    CHAIN_PROPERTY_OBJECT,
    MINER_SCHEDULE_OBJECT, //10
    BUDGET_RECORD_OBJECT,
    BUYING_OBJECT,
    CONTENT_OBJECT,
    PUBLISHER_OBJECT,
    SUBSCRIPTION_OBJECT, //15
    SEEDING_STATISTICS_OBJECT,
    TRANSACTION_DETAIL_OBJECT,
    MESSAGING_OBJECT;
    
    public var space: UInt8 {
        return rawValue < 10 ? 1 : 2
    }
    
    public var type: UInt8 {
        return rawValue - (space - 1) * 10
    }
    
    public var genericId: ChainObject {
        return ChainObject(from: self)
    }
}
