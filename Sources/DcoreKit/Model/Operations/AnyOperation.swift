import Foundation

public struct AnyOperation: Operation {
    
    public var fee: AssetAmount = .unset
    public var type: OperationType = .unknown
    public var base: Operation?
    
    private var data: Data = Data.ofZero
    
    init(_ type: OperationType) {
        self.type = type
    }

    init<Input>(_ input: Input) where Input: Operation {
        base = input
        fee =  input.fee
        type = input.type
        data = input.asData()
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        fee
    }
}

extension AnyOperation: DataEncodable {
    public func asData() -> Data {
        return data
    }
}

extension Array where Element: Operation {
    func asOperations() -> [AnyOperation] {
        return map({ AnyOperation($0) })
    }
}
