import Foundation

public struct OperationPair<T: BaseOperation>: Encodable {
    
    let operation: T
    
    init(_ operation: T) {
        self.operation = operation
    }
    
    public func encode(to encoder: Encoder) throws {
        var unkeyed = encoder.unkeyedContainer()
        try unkeyed.encode(operation.type)
        try unkeyed.encode(operation)
    }
}

extension Array where Element == BaseOperation {
    func asOperationPairs() -> [OperationPair<Element>] {
        return map({ OperationPair($0) })
    }
}

extension Array where Element == OperationPair<BaseOperation> {
    func asOperations() -> [BaseOperation] {
        return map({ $0.operation })
    }
}
