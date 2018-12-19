import Foundation
import BigInt

public struct AssetAmount: Codable {
    
    public let amount: BigInt
    public let assetId: ChainObject
    
    private enum CodingKeys: String, CodingKey {
        case
        amount,
        assetId = "asset_id"
    }
    
    public init(_ amount: BigInt, assetId: ChainObject = DCore.Constants.Defaults.DCT_ASSET_ID) {
        guard amount >= 0 else { preconditionFailure("amount must be greater or equal to 0") }
        guard assetId.objectType == ObjectType.ASSET_OBJECT else { preconditionFailure("object type is not an asset") }
        
        self.amount = amount
        self.assetId = assetId
    }
    
    public init(with amount: UInt64) {
        self.init(BigInt(amount))
    }
    
    public init(with amount: UInt64, assetId: String) {
        self.init(BigInt(amount), assetId: assetId.chainObject)
    }
    
    public init(with amount: String) {
        self.init(BigInt(amount)!)
    }
    
    public init(with amount: String, assetId: String) {
        self.init(BigInt(amount)!, assetId: assetId.chainObject)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.amount.description, forKey: .amount)
        try container.encode(self.assetId, forKey: .assetId)
    }
}

extension AssetAmount: Equatable {
    public static func == (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        return lhs.assetId == rhs.assetId && lhs.amount == rhs.amount
    }
}

extension AssetAmount: Comparable {
    public static func < (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        guard lhs.assetId == rhs.assetId else { preconditionFailure("cannot compare different asset id") }
        return lhs.amount < rhs.amount
    }
    
    public static func <= (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        guard lhs.assetId == rhs.assetId else { preconditionFailure("cannot compare different asset id") }
        return lhs.amount <= rhs.amount
    }
    
    public static func >= (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        guard lhs.assetId == rhs.assetId else { preconditionFailure("cannot compare different asset id") }
        return lhs.amount >= rhs.amount
    }
    
    public static func > (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        guard lhs.assetId == rhs.assetId else { preconditionFailure("cannot compare different asset id") }
        return lhs.amount > rhs.amount
    }
    
    public static func < (lhs: AssetAmount, rhs: Int) -> Bool {
        return lhs.amount < rhs
    }
    
    public static func <= (lhs: AssetAmount, rhs: Int) -> Bool {
        return lhs.amount <= rhs
    }
    
    public static func >= (lhs: AssetAmount, rhs: Int) -> Bool {
        return lhs.amount >= rhs
    }
    
    public static func > (lhs: AssetAmount, rhs: Int) -> Bool {
        return lhs.amount > rhs
    }
}

extension AssetAmount: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += amount
        data += assetId
        return data
    }
}
