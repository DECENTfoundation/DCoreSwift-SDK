import Foundation

public enum ObjectType: UInt8, CaseIterable, Codable {
    
    public init(fromSpace space: Int, type: Int) {
        self = ObjectType.allCases[max(space - 1, 0) * 10 + type]
    }
    
    // dcore/libraries/chain/include/graphene/chain/protocol/types.hpp
    // enum object_type, space = 1
    case
    nullObject = 0, // ordinal = 0, type = 0, space = any
    baseObject,
    accountObject,
    assetObject,
    minerObject,
    customObject, //5
    proposalObject,
    operationHistoryObject,
    withdrawPermissionObject,
    vestingBalanceObject,
    
    //  enum impl_object_type, space = 2
    globalPropertyObject, // ordinal = 10, type 0
    dynamicGlobalPropertyObject,
    reservedObject,
    assetDynamicData,
    accountBalanceObject,
    accountStatisticsObject, //5
    transactionObject,
    blockSummaryObject,
    accountTransactionHistoryObject,
    chainPropertyObject,
    minerScheduleObject, //10
    budgetRecordObject,
    buyingObject,
    contentObject,
    publisherObject,
    subscriptionObject, //15
    seedingStatisticsObject,
    transactionDetailObject,
    messagingObject
    
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
