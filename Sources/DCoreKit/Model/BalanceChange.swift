import Foundation

public struct BalanceChange<Input>: Codable where Input: Operation {
    
    public let operation: OperationHistory<Input>
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
