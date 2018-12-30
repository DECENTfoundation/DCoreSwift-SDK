import Foundation

public class BaseOperation: Codable {
    
    static let FEE_UNSET = AssetAmount(0)
    
    public let type: OperationType
    public var fee: AssetAmount = FEE_UNSET
    
    init(type: OperationType, fee: AssetAmount? = nil) {
        self.type = type
        self.fee = fee ?? BaseOperation.FEE_UNSET
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        type,
        fee
    }
}

extension BaseOperation: DataSerializable {}

extension BaseOperation: Equatable {
    public static func == (lhs: BaseOperation, rhs: BaseOperation) -> Bool {
        return lhs.serialized == rhs.serialized
    }
}
