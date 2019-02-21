import Foundation

public struct BalanceChange: Codable {
    
    public let history: OperationHistory
    public let balance: Balance
    public let fee: AssetAmount
    
    private enum CodingKeys: String, CodingKey {
        case
        history = "hist_object",
        balance,
        fee
    }
}

extension BalanceChange: Equatable {}

public struct Balance: Codable {
    
    public let primaryAsset: AssetAmount
    public let sencodaryAsset: AssetAmount
    
    private enum CodingKeys: String, CodingKey {
        case
        primaryAsset = "asset0",
        sencodaryAsset = "asset1"
    }
}

extension Balance: Equatable {}
