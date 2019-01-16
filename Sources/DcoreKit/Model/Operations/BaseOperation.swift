import Foundation

public class BaseOperation: Codable {
    
    static let feeUnset = AssetAmount(0)
    
    public let type: OperationType
    public var fee: AssetAmount = feeUnset
    
    init(type: OperationType, fee: AssetAmount? = nil) {
        self.type = type
        self.fee = fee ?? BaseOperation.feeUnset
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        type,
        fee
    }
    
    func apply(fee amount: AssetAmount) -> BaseOperation {
        fee = amount
        return self
    }
}

extension BaseOperation: DataSerializable {}

extension BaseOperation: Equatable {
    public static func == (lhs: BaseOperation, rhs: BaseOperation) -> Bool {
        return lhs.serialized == rhs.serialized
    }
}
