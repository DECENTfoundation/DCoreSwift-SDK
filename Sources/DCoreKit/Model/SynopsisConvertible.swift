import Foundation

public protocol SynopsisConvertible: Codable {
    var title: String { get }
    var description: String { get }
    var type: ChainObject { get }
}
