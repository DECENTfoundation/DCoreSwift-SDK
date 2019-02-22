import Foundation
import BigInt

public struct AnyOperation: Operation, OperationUnkeyedDecodable {
    
    public var fee: AssetAmount = .unset
    public var type: OperationType = .unknown

    public var operation: Operation

    init<Input>(_ input: Input) where Input: Operation {
        self.init(from: input)
    }
    
    private init(from input: Operation) {
        operation = input
        fee =       input.fee
        type =      input.type
    }
    
    public init(from decoder: Decoder) throws {
        self.init(from: try AnyOperation.decodeUnkeyed(from: try decoder.unkeyedContainer()))
    }
    
    public func encode(to encoder: Encoder) throws {
        try operation.encodeUnkeyed(to: encoder)
    }
}

extension AnyOperation {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> AnyOperation {
        var op = self
        op.operation = try operation.decrypt(keyPair, address: address, nonce: nonce)
        
        return op
    }
}

extension AnyOperation {
    public func asData() -> Data {
        return operation.asData()
    }
}

extension Array where Element == AnyOperation {
    public func asOperations() -> [Operation] {
        return map { $0.operation }
    }
}
