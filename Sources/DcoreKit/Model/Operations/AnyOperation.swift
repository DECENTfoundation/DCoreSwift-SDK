import Foundation

public struct AnyOperation: Operation {
    
    public var fee: AssetAmount = .unset
    public var type: OperationType = .unknown
    
    var operation: Operation?
    var data: Data?
    
    init(_ type: OperationType) {
        self.type = type
    }
    
    init<Input>(_ operation: Input) where Input: Operation {
        self.operation = operation
        self.fee = operation.fee
        self.type = operation.type
    }
    
    init<Input>(_ operation: Input) where Input: Operation & DataEncodable {
        self.operation = operation
        self.fee = operation.fee
        self.type = operation.type
        self.data = operation.asData()
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        fee
    }
}

extension AnyOperation: DataEncodable {
    func asData() -> Data {
        return data.or(Data.empty)
    }
}

extension Array where Element: Operation {
    func asAnyOperations() -> [AnyOperation] {
        return map({ AnyOperation($0) })
    }
}
