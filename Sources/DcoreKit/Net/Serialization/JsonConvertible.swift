import Foundation
import BigInt
import SwiftyJSON

protocol JsonConvertible {
    func asJsonDecoded<Output>(to type: Output.Type) throws -> Output where Output: Decodable
}

extension JsonConvertible where Self: DataEncodable {
    func asJsonDecoded<Output>(to type: Output.Type) throws -> Output where Output: Decodable {
        return try JSONDecoder.codingContext().decode(type, from: asEncoded())
    }
}

extension Data: JsonConvertible {}

extension Encodable {
    func asJsonData() throws -> Data {
        return try JSONEncoder.codingContext().encode(self)
    }
    
    func asJson() -> String? {
        return String(data: (try? asJsonData()) ?? Data.empty, encoding: .utf8)
    }
}
