import Foundation

public class BaseOperation: Codable {
    
    static let FEE_UNSET = AssetAmount(amount: 0)
    
    public let type: OperationType
    public var fee: AssetAmount = FEE_UNSET
}
