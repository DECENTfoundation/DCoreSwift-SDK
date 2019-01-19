import Foundation

public protocol SchemeConvertible {
    var type: Scheme { get }
}

public enum Scheme: String, Codable {
    case
    http,
    https,
    ipfs,
    unknown
}
