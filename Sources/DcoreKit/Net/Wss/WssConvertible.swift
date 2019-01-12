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
        guard let request = with(id: id).asJson() else { throw ChainException.network(.failEncode("Failed to encode data into json wss request")) }
        
        Logger.debug(network: "RPC wss request:\n%{private}s") { request }
        return request
    }
}
