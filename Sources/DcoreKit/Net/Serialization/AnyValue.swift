import Foundation

public enum AnyValue: Codable {
    
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case object([String:AnyValue])
    case array([AnyValue])
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String: AnyValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([AnyValue].self) {
            self = .array(value)
        } else {
            throw DecodingError.typeMismatch(AnyValue.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError("Not implemented")
    }
}

extension AnyValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .string(let value): return value
        case .int(let value): return "\(value)"
        case .double(let value): return "\(value)"
        case .bool(let value): return "\(value)"
        case .object(let value): return "\(value)"
        case .array(let value): return "\(value)"
        }
    }
}
