import Foundation

protocol WssResponseParser: CoreResponseParser {}

extension Data: WssResponseParser {}

extension WssResponseParser where Self: DataConvertible {
    
    func parse<Output>(validResponse req: BaseRequest<Output>) -> (Bool, Output?) where Output: Codable {
        return (true, try? parse(response: req, from: asData()))
    }
}
