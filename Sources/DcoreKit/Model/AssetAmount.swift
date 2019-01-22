import Foundation
import BigInt

public struct AssetAmount: Codable {
    
    public static let unset = AssetAmount(0)
    
    public let amount: BigInt
    public let assetId: ChainObject
    
    private enum CodingKeys: String, CodingKey {
        case
        amount,
        assetId = "asset_id"
    }
    
    public init(_ amount: BigInt, assetId: ChainObject = DCore.Constant.dct) {
        precondition(amount >= 0, "Amount must be greater or equal to 0")
        precondition(assetId.objectType == ObjectType.assetObject, "Object type is not an asset")
        
        self.amount = amount
        self.assetId = assetId
    }
    
    public init(with amount: UInt64) {
        self.init(BigInt(amount))
    }
    
    public init(with amount: UInt64, assetId: String) {
        guard let id = assetId.chain.chainObject else { preconditionFailure("Not valid asset id \(assetId)") }
        self.init(BigInt(amount), assetId: id)
    }
    
    public init(with amount: String) {
        self.init(BigInt(amount)!)
    }
    
    public init(with amount: String, assetId: String) {
        guard let id = assetId.chain.chainObject else { preconditionFailure("Not valid asset id \(assetId)") }
        self.init(BigInt(amount)!, assetId: id)
    }
}

extension AssetAmount {
    public typealias Pair = (asset: Asset, amount: AssetAmount)
}

extension AssetAmount: Equatable {
    public static func == (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        return lhs.assetId == rhs.assetId && lhs.amount == rhs.amount
    }
}

extension AssetAmount: Comparable {
    public static func < (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        precondition(lhs.assetId == rhs.assetId, "Cannot compare different asset id")
        return lhs.amount < rhs.amount
    }
    
    public static func <= (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        precondition(lhs.assetId == rhs.assetId, "Cannot compare different asset id")
        return lhs.amount <= rhs.amount
    }
    
    public static func >= (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        precondition(lhs.assetId == rhs.assetId, "Cannot compare different asset id")
        return lhs.amount >= rhs.amount
    }
    
    public static func > (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        precondition(lhs.assetId == rhs.assetId, "Cannot compare different asset id")
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

extension AssetAmount: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += UInt64(amount).littleEndian
        data += assetId.asData()
        
        Logger.debug(crypto: "AssetAmount binary: %{private}s", args: { "\(data.toHex()) (\(data)) \(data.bytes)"})
        return data
    }
}
