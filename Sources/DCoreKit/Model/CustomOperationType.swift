import Foundation

public enum CustomOperationType: Int16, Codable {
    case
    unknown = -1,
    null,
    messaging

    public init(from aDecoder: Decoder) throws {
        let container = try aDecoder.singleValueContainer()
        let rawValue: Int16 = try container.decode(Int16.self)
        self = CustomOperationType(rawValue: rawValue) ?? .unknown
    }
}

extension CustomOperationType: DataConvertible {
    public func asData() -> Data {
        return Data() + rawValue.littleEndian
    }
}
