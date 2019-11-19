import Foundation
import SwiftyJSON

enum ResponseResult<Output> where Output: Codable {
    case
    success(Output),
    failure(DCoreException)
}

enum ResponseKeypath: String {
    case
    result,
    error,
    method,
    params,
    data,
    id
}

protocol CoreResponseParser {
    
    func parse<Output>(response req: BaseRequest<Output>, from data: Data) throws -> Output where Output: Codable
    func parse<Output>(response req: BaseRequest<Output>, from json: JSON) throws -> Output where Output: Codable
}

private struct CoreResponse<T: Codable>: Codable {
    let result: T
}

extension CoreResponseParser {
    
    func parse<Output>(response req: BaseRequest<Output>, from data: Data) throws -> Output where Output: Codable {
        return try parse(response: req, from: try JSON(data: data))
    }
    
    func parse<Output>(response req: BaseRequest<Output>, from json: JSON) throws -> Output where Output: Codable {
        
        let error = json[ResponseKeypath.error.rawValue]
        let result = json[ResponseKeypath.result.rawValue]
        
        guard !error.exists() else {
            let stack = error[ResponseKeypath.data.rawValue]
            if let failure = try? stack.rawData().asJsonDecoded(to: DCoreException.Network.self) {
                throw DCoreException.network(failure)
            }
            
            throw DCoreException.network(.fail(error))
        }
        
        if result.exists() {
            do {
                if req.isResponseVoid() {
                    return try result.rawData().asJsonDecoded(to: req.returnType)
                }
                
                if result.null != nil || result.arrayValue.contains(.null) {
                    throw DCoreException.network(.notFound)
                }

                if result.dictionary.isNil() && result.array.isNil() {
                    // iOS 12 does not consider primitive stand-alone values as valid JSON objects, so this won't work:
                    // result.rawString().or("").asEncoded().asJsonDecoded(to: req.returnType)
                    // This piece: withUnsafeBytes(of: result.object, { $0.load(as: req.returnType) })
                    // Doesn't parse unsigned integers properly, so can't be used either
                    // To remain compatible with iOS 12, CoreResponse has been added.
                    // Once support of iOS 12 is not neccessary, consider JSON parsing from result variable directly.
                    return try json.rawString().or("").asEncoded().asJsonDecoded(to: CoreResponse.self).result
                }
                
                return try result.rawData().asJsonDecoded(to: req.returnType)
            } catch let error as DCoreException { throw error
            } catch let error {
                throw DCoreException.network(.failDecode("Failed to decode response for request:\n\(req.description)\nwith error:\n\(error)"))
            }
        }
        
        throw DCoreException.unexpected("Invalid api response for request:\n\(req.description)")
    }
}

extension Data: CoreResponseParser {}

extension CoreResponseParser where Self: DataEncodable {
    
    func parse<Output>(response req: BaseRequest<Output>) throws -> Output where Output: Codable {
        return try parse(response: req, from: asEncoded())
    }
}
