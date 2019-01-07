import Foundation

extension Encodable {
    func toJsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func toJson() throws -> String {
        guard let json = String(data: try toJsonData(), encoding: .utf8) else { throw CoreError.network(.failEncode("Not a json data")) }
        return json
    }
}

extension Data {
    func fromJson<Output: Decodable>(type: Output.Type, at path: String? = nil) throws -> Output {
        if let path = path {
            guard !path.isEmpty else { throw CoreError.unexpected("Json path not found, can't be empty string") }
            do {
                let json = try JSONSerialization.jsonObject(with: self, options: [])
                guard let nested = (json as AnyObject).value(forKeyPath: path) else {
                    throw CoreError.network(.failDecode("Json not found at path \(path)"))
                }
                
                let data = try JSONSerialization.data(withJSONObject: nested, options: [])
                return try JSONDecoder().decode(type, from: data)
                
            } catch let error {
                throw CoreError.underlying(error)
            }
        }
        return try JSONDecoder().decode(type, from: self)
    }
}
