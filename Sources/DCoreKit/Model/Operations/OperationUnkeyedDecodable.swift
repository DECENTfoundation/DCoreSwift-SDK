import Foundation

protocol OperationUnkeyedDecodable {
    static func decodeUnkeyed(from container: UnkeyedDecodingContainer) throws -> Operation
}

extension OperationUnkeyedDecodable {
    static func decodeUnkeyed(from container: UnkeyedDecodingContainer) throws -> Operation {
        var unkeyed = container
        
        let type = try unkeyed.decode(OperationType.self)
        switch type {
        case .transferOperation, .transferTwoOperation:
            return try unkeyed.decode(TransferOperation.self)
        case .contentSubmitOperation:
            return try unkeyed.decode(SubmitContentOperation.self)
        case .contentCancellationOperation:
            return try unkeyed.decode(SubmitContentOperation.self)
        case .requestToBuyOperation:
            return try unkeyed.decode(SubmitContentOperation.self)
        case .accountCreateOperation:
            return try unkeyed.decode(SubmitContentOperation.self)
        case .accountUpdateOperation:
            return try unkeyed.decode(SubmitContentOperation.self)
        default:
            return try unkeyed.decode(SubmitContentOperation.self)
        }
    }
}
