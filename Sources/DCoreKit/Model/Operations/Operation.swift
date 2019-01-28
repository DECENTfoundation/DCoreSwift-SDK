import Foundation

public protocol Operation: DataConvertible, CipherConvertible, Codable {
    var type: OperationType { get }
    var fee: AssetAmount { get set }
    
    func apply(fee amount: AssetAmount) -> Self
    func asData() -> Data
}

extension Operation {
    public func apply(fee amount: AssetAmount) -> Self {
        var op = self
        op.fee = amount
        
        return op
    }
}
