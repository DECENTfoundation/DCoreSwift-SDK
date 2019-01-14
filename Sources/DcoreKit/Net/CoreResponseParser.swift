import Foundation
import SwiftyJSON

enum ResponseResult<Output> where Output: Codable {
    case
    success(Output),
    failure(ChainException)
}

enum ResponseKeypath: String {
    case
    result,
    error,
    method,
    params,
    id
}

protocol CoreResponseParser {
    
    func parse<Output>(response req: BaseRequest<Output>, from data: Data) throws -> Output where Output: Codable
    func parse<Output>(response req: BaseRequest<Output>, from json: JSON) throws -> Output where Output: Codable
}

extension CoreResponseParser {
    
    func parse<Output>(response req: BaseRequest<Output>, from data: Data) throws -> Output where Output: Codable {
        return try parse(response: req, from: try JSON(data: data))
    }
    
    func parse<Output>(response req: BaseRequest<Output>, from json: JSON) throws -> Output where Output: Codable {
        
        let error = json[ResponseKeypath.error.rawValue]
        let result = json[ResponseKeypath.result.rawValue]
        
        guard !error.exists() else { throw ChainException.network(.fail(error)) }
        
        if result.exists() {
            do {
                if req.isResponseVoid() {
                    return try result.rawData().asJsonDecoded(to: req.returnClass)
                }
                
                guard result.null == nil || !(result.array ?? []).contains(.null) else {
                    throw ChainException.network(.notFound)
                }
                
                return try result.rawData().asJsonDecoded(to: req.returnClass)
            } catch let error as ChainException { throw error
            } catch {
                throw ChainException.network(.failDecode("Failed to decode response for request:\n\(req.description)"))
            }
        }
        
        throw ChainException.unexpected("Invalid api response for request:\n\(req.description)")
    }
}

extension Data: CoreResponseParser {}

extension CoreResponseParser where Self: DataConvertible {
    
    func parse<Output>(response req: BaseRequest<Output>) throws -> Output where Output: Codable {
        return try parse(response: req, from: asData())
    }
}
