import Foundation

struct RequiredFee<T: BaseOperation>: Encodable {
    
    let operation: T
    
    init(_ operation: T) {
        self.operation = operation
    }
    
    func encode(to encoder: Encoder) throws {
        var unkeyed = encoder.unkeyedContainer()
        try unkeyed.encode(operation.type)
        try unkeyed.encode(operation)
    }
}
