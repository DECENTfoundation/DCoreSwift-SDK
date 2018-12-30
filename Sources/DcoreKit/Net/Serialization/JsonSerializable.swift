import Foundation

extension Encodable {
    func toJsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func toJson() throws -> String {
        guard let json = String(data: try toJsonData(), encoding: .utf8) else { throw DCoreError.illegal("Not a json data") }
        return json
    }
}

extension Data {
    func fromJson<Output: Decodable>(type: Output.Type, at path: String? = nil) throws -> Output {
        if let path = path {
            guard !path.isEmpty else { throw DCoreError.illegal("json path not found") }
            do {
                let json = try JSONSerialization.jsonObject(with: self, options: [])
                guard let nested = (json as AnyObject).value(forKeyPath: path) else {
                    throw DCoreError.illegal("json not found at path \(path)")
                }
                
                let data = try JSONSerialization.data(withJSONObject: nested, options: [])
                return try JSONDecoder().decode(type, from: data)
                
            } catch let error {
                throw DCoreError.underlying(error)
            }
        }
        return try JSONDecoder().decode(type, from: self)
    }
}
