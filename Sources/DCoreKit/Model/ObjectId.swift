import Foundation

public class ObjectId: Codable {
    public static let nullObjectId: ObjectId = ObjectId(instance: 0)
    public static func genericId() -> Self {
        return Self(instance: 0)
    }

    public private(set) var objectType: ObjectType = .nullObject
    public let instance: UInt64

    required public init(instance: UInt64) {
        self.instance = instance
    }

    required init(from id: String) throws {
        let result = id.matches(regex: "(\\d+)\\.(\\d+)\\.(\\d+)(?:\\.(\\d+))?")
        guard !result.isEmpty else { throw DCoreException.unexpected("Object Id \(id) has invalid format") }
        
        let parts = id.components(separatedBy: ".")

        objectType = ObjectType(fromSpace: Int(parts[0]).or(0), type: Int(parts[1]).or(0))
        instance = UInt64(parts[2]).or(0)
    }

    required public convenience init(from decoder: Decoder) throws {
        let id = try decoder.singleValueContainer().decode(String.self)
        try self.init(from: id)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(asString())
    }

    public func asString() -> String { "\(objectType.space).\(objectType.type).\(instance)" }
}

extension ObjectId: CustomStringConvertible {
    public var description: String { asString() }
}

extension ObjectId: DataConvertible {
    public func asFullData() -> Data {
        var bytes = Data()
        bytes += UInt64((UInt64(objectType.space) << 56) | UInt64(objectType.type) << 48 | instance).littleEndian
        return bytes
    }
    
    public func asData() -> Data {
        let data = instance.asUnsignedVarIntData()
        DCore.Logger.debug(crypto: "Object Id binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}

extension ObjectId: Equatable {
    public static func == (lhs: ObjectId, rhs: ObjectId) -> Bool {
        return lhs.asString() == rhs.asString()
    }
}

extension ObjectId: Comparable {
    public static func < (lhs: ObjectId, rhs: ObjectId) -> Bool {
        return lhs.objectType < rhs.objectType || (lhs.objectType == rhs.objectType && lhs.instance < rhs.instance)
    }
    
    public static func <= (lhs: ObjectId, rhs: ObjectId) -> Bool {
        return lhs == rhs || lhs < rhs
    }
    
    public static func >= (lhs: ObjectId, rhs: ObjectId) -> Bool {
        return lhs == rhs || lhs > rhs
    }
    
    public static func > (lhs: ObjectId, rhs: ObjectId) -> Bool {
        return lhs.objectType > rhs.objectType || (lhs.objectType == rhs.objectType && lhs.instance > rhs.instance)
    }
}

extension ObjectId: Hashable {
    public func hash(into hasher: inout Hasher) {
        asString().hash(into: &hasher)
    }
}

extension DCoreExtension where Base == String {
    public func objectId<T: ObjectId>() -> T? {
        return try? T(from: self.base)
    }
}

public final class BaseObjectId: ObjectId {
    public override var objectType: ObjectType { .baseObject }
}

public final class AccountObjectId: ObjectId {
    public override var objectType: ObjectType { .accountObject }
}

public final class AssetObjectId: ObjectId {
    public override var objectType: ObjectType { .assetObject }
}

public final class MinerObjectId: ObjectId {
    public override var objectType: ObjectType { .minerObject }
}

public final class CustomObjectId: ObjectId {
    public override var objectType: ObjectType { .customObject }
}

public final class ProposalObjectId: ObjectId {
    public override var objectType: ObjectType { .proposalObject }
}

public final class OperationHistoryObjectId: ObjectId {
    public override var objectType: ObjectType { .operationHistoryObject }
}

public final class WithdrawPermissionObjectId: ObjectId {
    public override var objectType: ObjectType { .withdrawPermissionObject }
}

public final class VestingBalanceObjectId: ObjectId {
    public override var objectType: ObjectType { .vestingBalanceObject }
}

public final class NftObjectId: ObjectId {
    public override var objectType: ObjectType { .nftObject }
}

public final class NftDataObjectId: ObjectId {
    public override var objectType: ObjectType { .nftDataObject }
}

public final class GlobalPropertyObjectId: ObjectId {
    public override var objectType: ObjectType { .globalPropertyObject }
}

public final class DynamicGlobalPropertyObjectId: ObjectId {
    public override var objectType: ObjectType { .dynamicGlobalPropertyObject }
}

public final class ReservedObjectId: ObjectId {
    public override var objectType: ObjectType { .reservedObject }
}

public final class AssetDataObjectId: ObjectId {
    public override var objectType: ObjectType { .assetDynamicData }
}

public final class AccountBalanceObjectId: ObjectId {
    public override var objectType: ObjectType { .accountBalanceObject }
}

public final class AccountStatsObjectId: ObjectId {
    public override var objectType: ObjectType { .accountStatisticsObject }
}

public final class TransactionObjectId: ObjectId {
    public override var objectType: ObjectType { .transactionObject }
}

public final class BlockSummaryObjectId: ObjectId {
    public override var objectType: ObjectType { .blockSummaryObject }
}

public final class AccountTransactionObjectId: ObjectId {
    public override var objectType: ObjectType { .accountTransactionHistoryObject }
}

public final class ChainPropertyObjectId: ObjectId {
    public override var objectType: ObjectType { .chainPropertyObject }
}

public final class MinerScheduleObjectId: ObjectId {
    public override var objectType: ObjectType { .minerScheduleObject }
}

public final class BudgetRecordObjectId: ObjectId {
    public override var objectType: ObjectType { .budgetRecordObject }
}

public final class PurchaseObjectId: ObjectId {
    public override var objectType: ObjectType { .purchaseObject }
}

public final class ContentObjectId: ObjectId {
    public override var objectType: ObjectType { .contentObject }
}

public final class PublisherObjectId: ObjectId {
    public override var objectType: ObjectType { .publisherObject }
}

public final class SubscriptionObjectId: ObjectId {
    public override var objectType: ObjectType { .subscriptionObject }
}

public final class SeedingStatsObjectId: ObjectId {
    public override var objectType: ObjectType { .seedingStatisticsObject }
}

public final class TransactionDetailObjectId: ObjectId {
    public override var objectType: ObjectType { .transactionDetailObject }
}

public final class MessagingObjectId: ObjectId {
    public override var objectType: ObjectType { .messagingObject }
}
