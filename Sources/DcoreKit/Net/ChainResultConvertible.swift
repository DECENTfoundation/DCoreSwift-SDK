import Foundation

protocol ChainResultConvertible: Decodable {
    var result: Data { get }
}

extension ChainResultConvertible {
    var result: Data { fatalError("Override required") }
}
