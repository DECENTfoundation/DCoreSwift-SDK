import Foundation
import BigInt

public struct AssetData: Codable {
    public var id: AssetDataObjectId = .genericId()
    public let currentSupply: BigInt
    public let assetPool: BigInt
    public let corePool: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        currentSupply = "current_supply",
        assetPool = "asset_pool",
        corePool = "core_pool"
    }
}
