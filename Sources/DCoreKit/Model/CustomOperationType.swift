import Foundation

public enum CustomOperationType: Int, Codable {
    case
    unknown = -1,
    null,
    messaging

    public init(from aDecoder: Decoder) throws {
        let container = try aDecoder.singleValueContainer()
        self = CustomOperationType(rawValue: try container.decode(Int.self)) ?? .unknown
    }
}
