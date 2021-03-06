import Foundation

public protocol Operation: DataConvertible, CipherConvertible, AnyOperationConvertible, OperationUnkeyedEncodable, Codable {
    var type: OperationType { get }
    var fee: AssetAmount { get set }
    
    func apply(fee amount: AssetAmount) -> Self
    func to<Output>(type: Output.Type) throws -> Output where Output: Operation
    func `is`<Output>(type: Output.Type) -> Bool where Output: Operation
}

public protocol HasOperation {
    func hasOperation<Output>(type: Output.Type) -> Bool where Output: Operation
}

public protocol TypedOperationConvertible: HasOperation {
    func toOperation<Output>(type: Output.Type) throws -> Output where Output: Operation
}

extension Operation {
    public func apply(fee amount: AssetAmount) -> Self {
        var op = self
        op.fee = amount
        
        return op
    }
    
    public func to<Output>(type: Output.Type) throws -> Output where Output: Operation {
        guard let cast = self as? Output else { throw DCoreException.unexpected("Operration \(self) could not be casted to \(type)") }
        return cast
    }
    
    public func `is`<Output>(type: Output.Type) -> Bool where Output: Operation {
        return (try? to(type: type)) != nil
    }
}

extension Operation {
    public func asAnyOperation() -> AnyOperation {
        return AnyOperation(self)
    }
}

extension HasOperation {
    public func hasOperation<Output>(type: Output.Type) -> Bool where Output: Operation {
        return false
    }
}
