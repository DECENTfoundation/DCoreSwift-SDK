import Foundation

public struct UnknownOperation: Operation {
    
    public var fee: AssetAmount = .unset
    public let type: OperationType = .unknown
    
    public var raw: AnyValue
    
    public init(from decoder: Decoder) throws {
        raw = try decoder.singleValueContainer().decode(AnyValue.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(raw)
    }
}
