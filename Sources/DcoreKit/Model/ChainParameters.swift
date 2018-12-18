import Foundation

public struct ChainParameters: Codable {
    public let minMinerCount: Int
    public let specialAccounts: Int
    public let specialAssets: Int
    
    private enum CodingKeys: String, CodingKey {
        case
        minMinerCount = "min_miner_count",
        specialAccounts = "num_special_accounts",
        specialAssets = "num_special_assets"
    }
}
