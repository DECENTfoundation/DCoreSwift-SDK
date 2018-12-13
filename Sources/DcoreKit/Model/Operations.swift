import Foundation

public class BaseOperation: Codable {
    
    static let FEE_UNSET = AssetAmount(amount: 0)
    
    public let type: OperationType
    public var fee: AssetAmount = FEE_UNSET
    
    init(type: OperationType, fee: AssetAmount = FEE_UNSET) {
        self.type = type
        self.fee = fee
    }
}

extension BaseOperation: ByteSerializable {}

final class EmptyOperation: BaseOperation {}

extension EmptyOperation: CustomStringConvertible {
    
    public var description: String {
        return self.type.description
    }
}
