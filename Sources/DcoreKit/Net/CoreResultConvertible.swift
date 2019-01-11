import Foundation

protocol CoreResultConvertible: Decodable {
    var result: Data { get }
}

extension CoreResultConvertible {
    var result: Data { fatalError("Override required") }
}
