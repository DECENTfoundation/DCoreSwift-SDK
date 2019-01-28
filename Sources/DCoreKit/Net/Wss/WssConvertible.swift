import Foundation

protocol WssConvertible {
    func asWss() throws -> String
}

extension WssConvertible where Self: Encodable {
    func asWss() throws -> String {
        guard let req = asJson() else {
            throw DCoreException.network(.failEncode("Failed to encode data into json wss request"))
        }
        
        DCore.Logger.debug(network: "RPC wss request:\n%{private}s") { req }
        return req
    }
}
