import Foundation

public struct BalanceChange: Codable {
    
    public let operation: OperationHistory
    public let balance: Balance
    public let fee: AssetAmount
    
    private enum CodingKeys: String, CodingKey {
        case
        operation = "hist_object",
        balance,
        fee
    }
}



public struct Balance: Codable {
    public let primaryAsset: AssetAmount
    public let sencodaryAsset: AssetAmount
    
    private enum CodingKeys: String, CodingKey {
        case
        primaryAsset = "asset0",
        sencodaryAsset = "asset1"
    }
}
