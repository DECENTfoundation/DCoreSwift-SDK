import Foundation

public struct OperationParameter<T: Operation>: Encodable {
    
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

extension Array where Element: Operation {    
    func asParamters() -> [OperationParameter<Element>] {
        return map({ OperationParameter($0) })
    }
}
