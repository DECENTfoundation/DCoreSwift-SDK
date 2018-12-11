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
        guard amount >= BigInt(0) else { preconditionFailure("Amount must be greater or equal to 0") }
        guard assetId.objectType == ObjectType.ASSET_OBJECT else { preconditionFailure("Object type is not an asset") }
        
        self.amount = amount
        self.assetId = assetId
    }
    
    public init(with amount: UInt64) { self.init(amount: BigInt(amount)) }
    public init(with amount: UInt64, asset: String) { self.init(amount: BigInt(amount), assetId: asset.toChainObject()) }
}

extension AssetAmount: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not implemeted Bytes.concat(amount.toLong().bytes(), assetId.bytes)")
    }
}
