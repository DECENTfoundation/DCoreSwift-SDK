import Foundation

public class BaseOperation: Codable {
    
    static let FEE_UNSET = AssetAmount(amount: 0)
    
    public let type: OperationType
    public var fee: AssetAmount = FEE_UNSET
    
    init(type: OperationType, fee: AssetAmount = FEE_UNSET) {
        self.type = type
        self.fee = fee
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        type,
        fee
    }
}

extension BaseOperation: DataSerializable {
    public var serialized: Data {
        return Data(bytes: [])
    }
}

final class EmptyOperation: BaseOperation {}

extension EmptyOperation: CustomStringConvertible {
    
    public var description: String {
        return self.type.description
    }
}
