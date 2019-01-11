import Foundation
import BigInt

protocol JsonConvertible {
    func asJsonDecoded<Output>(to type: Output.Type, at path: String?) throws -> Output where Output: Decodable
    func asJsonDecoded<Output>(to req: BaseRequest<Output>, _ validate: ((Data) throws -> ChainResultConvertible)?) throws -> Output where Output: Decodable
}

extension JsonConvertible where Self: DataConvertible {
    func asJsonDecoded<Output>(to type: Output.Type, at path: String? = nil) throws -> Output where Output: Decodable {
        
        if let path = path {
            guard !path.isEmpty else {
                throw ChainException.unexpected("Json path not found, can't be empty string")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: asData(), options: [])
                guard let nested = (json as AnyObject).value(forKeyPath: path) else {
                    throw ChainException.network(.failDecode("Json not found at path \(path)"))
                }
                
                let data = try JSONSerialization.data(withJSONObject: nested, options: [])
                return try JSONDecoder.codingContext().decode(type, from: data)
                
            } catch let error {
                throw ChainException.underlying(error)
            }
        }
        return try JSONDecoder.codingContext().decode(type, from: asData())
    }
    
    func asJsonDecoded<Output>(to req: BaseRequest<Output>, _ validate: ((Data) throws -> ChainResultConvertible)? = nil) throws -> Output where Output: Decodable {
        guard let validate = validate else { return try asData().asJsonDecoded(to: req.returnClass, at: req.returnKeypath) }
        
        let data = try validate(asData())
        return try data.result.asJsonDecoded(to: req.returnClass, at: req.returnKeypath)
    }
}

extension Data: JsonConvertible {}

extension Encodable {
    func asJsonData() throws -> Data {
        return try JSONEncoder.codingContext().encode(self)
    }
    
    func asJson() throws -> String {
        guard let json = String(data: try asJsonData(), encoding: .utf8) else { throw ChainException.network(.failEncode("Not a json data")) }
        return json
    }
}
