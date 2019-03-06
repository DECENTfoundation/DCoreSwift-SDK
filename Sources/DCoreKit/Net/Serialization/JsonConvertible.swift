import Foundation
import BigInt
import SwiftyJSON

public protocol JsonConvertible {
    func asJsonDecoded<Output>(to type: Output.Type) throws -> Output where Output: Decodable
}

extension JsonConvertible where Self: DataEncodable {
    public func asJsonDecoded<Output>(to type: Output.Type) throws -> Output where Output: Decodable {
        return try JSONDecoder.codingContext().decode(type, from: asEncoded())
    }
}

extension Data: JsonConvertible {}

extension Encodable {
    public func asJsonData() throws -> Data {
        return try JSONEncoder.codingContext().encode(self)
    }
    
    public func asJsonObject() throws -> Any {
        return try JSONSerialization.jsonObject(with: try asJsonData(), options: [])
    }
    
    public func asJson() -> String? {
        return String(data: (try? asJsonData()) ?? Data.empty, encoding: .utf8)
    }
}
