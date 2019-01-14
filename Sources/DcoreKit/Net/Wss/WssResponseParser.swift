import Foundation
import SwiftyJSON

protocol WssResponseParser: CoreResponseParser {}

extension Data: WssResponseParser {}

extension WssResponseParser where Self: DataConvertible {
    
    func parse<Output>(validResponse req: BaseRequest<Output>) -> (Bool, ResponseResult<Output>) where Output: Codable {
        do {
            let (valid, json) = try validate(response: req)
            do {
                return (valid, valid ?
                    .success(try parse(response: req, from: json)) :
                    .failure(ChainException.unexpected("Not valid wss response for request:\n\(req.description)"))
                )
                
            } catch let error {
                return (valid, .failure(error.asChainException()))
            }
        } catch let error {
            return (false, .failure(error.asChainException()))
        }
    }
    
    private func validate<Output>(response req: BaseRequest<Output>) throws -> (Bool, JSON) where Output: Codable {
        
        let json = try JSON(data: asData())
        let method = json[ResponseKeypath.method.rawValue]
        
        if let notice = method.string, case .notice? = ApiMethod(rawValue: notice), method.exists() {
            let params = json[ResponseKeypath.params.rawValue]
            return (params[0].uInt64 == req.callbackId ?? req.callId, params[1][0])
        } else {
            let id = json[ResponseKeypath.id.rawValue].uInt64
            return (id == req.callbackId ?? req.callId, json)
        }
    }
}
