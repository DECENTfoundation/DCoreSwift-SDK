import Foundation

public struct VestingBalance: Codable {
    
    public let id: VestingBalanceObjectId
    public let owner: AccountObjectId
    public let balance: AssetAmount
    public let policy: AnyValue?
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        owner,
        balance,
        policy
    }
}
