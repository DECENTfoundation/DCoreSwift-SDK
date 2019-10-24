import Foundation

public enum AnyValue: Codable, Equatable {
    
    case
    string(String),
    int(Int),
    uint64(UInt64),
    double(Double),
    bool(Bool),
    object([String:AnyValue]),
    array([AnyValue]),
    null
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(UInt64.self) {
            self = .uint64(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String: AnyValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([AnyValue].self) {
            self = .array(value)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.typeMismatch(
                AnyValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON")
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value): try container.encode(value)
        case .int(let value): try container.encode(value)
        case .uint64(let value): try container.encode(value)
        case .double(let value): try container.encode(value)
        case .bool(let value): try container.encode(value)
        case .object(let value): try container.encode(value)
        case .array(let value): try container.encode(value)
        case .null: try container.encodeNil()
        }
    }
}

extension AnyValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .string(let value): return value
        case .int(let value): return "\(value)"
        case .uint64(let value): return "\(value)"
        case .double(let value): return "\(value)"
        case .bool(let value): return "\(value)"
        case .object(let value): return "\(value)"
        case .array(let value): return "\(value)"
        case .null: return "null"
        }
    }
}
