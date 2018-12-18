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
    
    public init(amount: BigInt, assetId: ChainObject = DCore.Constants.Defaults.DCT_ASSET_ID) {
        guard amount >= 0 else { preconditionFailure("amount must be greater or equal to 0") }
        guard assetId.objectType == ObjectType.ASSET_OBJECT else { preconditionFailure("object type is not an asset") }
        
        self.amount = amount
        self.assetId = assetId
    }
    
    public init(with amount: UInt64) {
        self.init(amount: BigInt(amount))
    }
    
    public init(with amount: UInt64, assetId: String) {
        self.init(amount: BigInt(amount), assetId: assetId.chainObject)
        
    }
}

extension AssetAmount: Equatable {
    public static func == (lhs: AssetAmount, rhs: AssetAmount) -> Bool {
        return lhs.assetId == rhs.assetId && lhs.amount == rhs.amount
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
