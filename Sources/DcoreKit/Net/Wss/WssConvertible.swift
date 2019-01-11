import Foundation

protocol WssConvertible {

    func with(id: UInt64) -> Self
    func asWss(id: UInt64) throws -> String
}

extension WssConvertible where Self: Encodable {
    func with(id: UInt64) -> Self {
        fatalError("Override required")
    }
    
    func asWss(id: UInt64) throws -> String {
        
        let request = try with(id: id).asJson()
        Logger.debug(network: "RPC wss request:\n%{private}s") { request }
        
        return request
    }
}
