import Foundation
import BigInt

public struct AccountBalance: Codable {
    
    public let id: AccountBalanceObjectId
    public let owner: AccountObjectId
    public let assetType: AssetObjectId
    public let balance: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        owner,
        assetType = "asset_type",
        balance
    }
}
