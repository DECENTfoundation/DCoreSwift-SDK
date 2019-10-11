import Foundation

public enum ObjectType {
    
    public static let unset: ChainObject = ObjectType.nullObject.genericId
    public static let unsetHistory: ChainObject = ObjectType.operationHistoryObject.genericId
    
    public init(fromSpace space: Int, type: Int) {
        let unknown = ObjectType.unknown(UInt8(space), UInt8(type))
        switch space {
        case 1: self = ProtocolObjectType(rawValue: UInt8(type))?.toObjectType() ?? unknown
        case 2: self = ImplObjectType(rawValue: UInt8(type))?.toObjectType() ?? unknown
        default: self = unknown
        }
    }

    // dcore/libraries/chain/include/graphene/chain/protocol/types.hpp
    // enum object_type, space = 1
    private enum ProtocolObjectType: UInt8, CaseIterable {
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
        nftObject, // 10
        nftDataObject

        func toObjectType() -> ObjectType {
            switch self {
            case .nullObject: return .nullObject
            case .baseObject: return .baseObject
            case .accountObject: return .accountObject
            case .assetObject: return .assetObject
            case .minerObject: return .minerObject
            case .customObject: return .customObject
            case .proposalObject: return .proposalObject
            case .operationHistoryObject: return .operationHistoryObject
            case .withdrawPermissionObject: return .withdrawPermissionObject
            case .vestingBalanceObject: return .vestingBalanceObject
            case .nftObject: return .nftObject
            case .nftDataObject: return .nftDataObject
            }
        }
    }

    //  enum impl_object_type, space = 2
    private enum ImplObjectType: UInt8, CaseIterable {
        case
        globalPropertyObject, // ordinal = 0
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
        purchaseObject,
        contentObject,
        publisherObject,
        subscriptionObject, //15
        seedingStatisticsObject,
        transactionDetailObject,
        messagingObject

        // swiftlint:disable cyclomatic_complexity
        func toObjectType() -> ObjectType {
            switch self {
            case .globalPropertyObject: return .globalPropertyObject
            case .dynamicGlobalPropertyObject: return .dynamicGlobalPropertyObject
            case .reservedObject: return .reservedObject
            case .assetDynamicData: return .assetDynamicData
            case .accountBalanceObject: return .accountBalanceObject
            case .accountStatisticsObject: return .accountStatisticsObject
            case .transactionObject: return .transactionObject
            case .blockSummaryObject: return .blockSummaryObject
            case .accountTransactionHistoryObject: return .accountTransactionHistoryObject
            case .chainPropertyObject: return .chainPropertyObject
            case .minerScheduleObject: return .minerScheduleObject
            case .budgetRecordObject: return .budgetRecordObject
            case .purchaseObject: return .purchaseObject
            case .contentObject: return .contentObject
            case .publisherObject: return .publisherObject
            case .subscriptionObject: return .subscriptionObject
            case .seedingStatisticsObject: return .seedingStatisticsObject
            case .transactionDetailObject: return .transactionDetailObject
            case .messagingObject: return .messagingObject
            }
        }
        // swiftlint:enable cyclomatic_complexity
    }

    // enum object_type, space = 1
    case
    unknown(UInt8, UInt8),
    nullObject,
    baseObject,
    accountObject,
    assetObject,
    minerObject,
    customObject,
    proposalObject,
    operationHistoryObject,
    withdrawPermissionObject,
    vestingBalanceObject,
    nftObject,
    nftDataObject,
    
    //  enum impl_object_type, space = 2
    globalPropertyObject,
    dynamicGlobalPropertyObject,
    reservedObject,
    assetDynamicData,
    accountBalanceObject,
    accountStatisticsObject,
    transactionObject,
    blockSummaryObject,
    accountTransactionHistoryObject,
    chainPropertyObject,
    minerScheduleObject,
    budgetRecordObject,
    purchaseObject,
    contentObject,
    publisherObject,
    subscriptionObject,
    seedingStatisticsObject,
    transactionDetailObject,
    messagingObject
    
    public var space: UInt8 {
        if case let .unknown(space, _) = self {
            return space
        } else if ProtocolObjectType.isFromThisSpace(type: self) {
            return 1
        } else if ImplObjectType.isFromThisSpace(type: self) {
            return 2
        } else {
            preconditionFailure("""
                Could not get object type space.
                Is the Object Type defined in either ProtocolObjectType or ImplObjectType?
            """)
        }
    }
    
    public var type: UInt8 {
        if case let .unknown(_, type) = self {
            return type
        }

        if let objectType = ProtocolObjectType.allCases.first(where: { "\($0)" == "\(self)" })?.rawValue
            ?? ImplObjectType.allCases.first(where: { "\($0)" == "\(self)" })?.rawValue {
            return objectType
        } else {
            preconditionFailure("""
                Could not get object type space.
                Is the Object Type defined in either ProtocolObjectType or ImplObjectType?
            """)
        }
    }
    
    public var genericId: ChainObject {
        return ChainObject(from: self)
    }
}

extension ObjectType: Equatable {
    public static func == (lhs: ObjectType, rhs: ObjectType) -> Bool {
        return lhs.space == rhs.space && lhs.type == rhs.type
    }
}

extension ObjectType: Comparable {
    public static func < (lhs: ObjectType, rhs: ObjectType) -> Bool {
        return lhs.space < rhs.space || (lhs.space == rhs.space && lhs.type < rhs.type)
    }
    
    public static func <= (lhs: ObjectType, rhs: ObjectType) -> Bool {
        return lhs == rhs || lhs < rhs
    }
    
    public static func >= (lhs: ObjectType, rhs: ObjectType) -> Bool {
        return lhs == rhs || lhs > rhs
    }
    
    public static func > (lhs: ObjectType, rhs: ObjectType) -> Bool {
        return lhs.space > rhs.space || (lhs.space == rhs.space && lhs.type > rhs.type)
    }
}

private extension CaseIterable {
    static func isFromThisSpace(type: ObjectType) -> Bool {
        return allCases.map { "\($0)" }.contains("\(type)")
    }
}
