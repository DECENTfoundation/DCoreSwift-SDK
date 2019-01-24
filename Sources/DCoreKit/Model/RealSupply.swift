import Foundation
import BigInt

public struct RealSupply: Codable {
    
    public let accountBalances: BigInt
    public let vestingBalances: BigInt
    public let escrows: BigInt
    public let pools: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        accountBalances = "account_balances",
        vestingBalances = "vesting_balances",
        escrows,
        pools
    }
}
