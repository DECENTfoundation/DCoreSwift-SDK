import Foundation

public enum OperationResult: Codable, Equatable {
    
    case
    int(Int),
    chainObject(ChainObject),
    array([OperationResult]),
    null
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(ChainObject.self) {
            self = .chainObject(value)
        } else if let value = try? container.decode([OperationResult].self) {
            self = .array(value)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.typeMismatch(
                OperationResult.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON")
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value): try container.encode(value)
        case .chainObject(let value): try container.encode(value)
        case .array(let value): try container.encode(value)
        case .null: try container.encodeNil()
        }
    }
}

extension OperationResult: CustomStringConvertible {
    public var description: String {
        switch self {
        case .int(let value): return "\(value)"
        case .chainObject(let value): return "\(value)"
        case .array(let value): return "\(value)"
        case .null: return "null"
        }
    }
}
