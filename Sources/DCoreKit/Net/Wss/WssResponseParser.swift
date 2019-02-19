import Foundation
import SwiftyJSON

protocol WssResponseParser: CoreResponseParser {}

extension Data: WssResponseParser {}

extension WssResponseParser where Self: DataEncodable {
    
    func parse<Output>(validResponse req: BaseRequest<Output>) -> (Bool, ResponseResult<Output>) where Output: Codable {
        do {
            let (valid, json) = try validate(response: req)
            do {
                return (valid, valid ?
                    .success(try parse(response: req, from: json)) :
                    .failure(DCoreException.unexpected("Not valid wss response for request:\n\(req.description)"))
                )
                
            } catch let error {
                return (error.asDCoreException() != .network(.notFound), .failure(error.asDCoreException()))
            }
        } catch let error {
            return (false, .failure(error.asDCoreException()))
        }
    }
    
    private func validate<Output>(response req: BaseRequest<Output>) throws -> (Bool, JSON) where Output: Codable {
        
        let json = try JSON(data: asEncoded())
        let method = json[ResponseKeypath.method.rawValue]
        
        if let notice = method.string, case .notice? = ApiMethod(rawValue: notice), method.exists() {
            let params = json[ResponseKeypath.params.rawValue]
            var newJson = JSON()
            newJson[ResponseKeypath.result.rawValue] = params[1][0]
            return (params[0].uInt64 == req.callbackId ?? req.callId, newJson)
        } else {
            let id = json[ResponseKeypath.id.rawValue].uInt64
            return (id == req.callbackId ?? req.callId, json)
        }
    }
}
