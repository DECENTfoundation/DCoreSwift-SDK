import Foundation

public struct FullAccount: Codable {
    public let account: Account
    public let statistics: AccountStatistics
    public let registrarName: String
    public let votes: [Miner]
    public let balances: [AccountBalance]
    public let vestingBalances: [Any]
    public let proposals: [Any]
    
    private enum CodingKeys: String, CodingKey {
        case
        account,
        statistics,
        registrarName = "registrar_name",
        votes,
        balances,
        vestingBalances = "vesting_balances",
        proposals
    }
}
