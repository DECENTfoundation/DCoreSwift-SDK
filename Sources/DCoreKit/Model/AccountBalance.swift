import Foundation
import BigInt

public struct AccountBalance: Codable {
    
    public let id: ChainObject
    public let owner: ChainObject
    public let assetType: ChainObject
    public let balance: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        owner,
        assetType = "asset_type",
        balance
    }
}
