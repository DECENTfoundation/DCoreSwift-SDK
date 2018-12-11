import Foundation

public struct VestingBalance: Codable {
    
    public let owner: ChainObject
    public let balance: AssetAmount
    public let policy: Any
    
    private enum CodingKeys: String, CodingKey {
        case
        owner,
        balance,
        policy
    }
}
