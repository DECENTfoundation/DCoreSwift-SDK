import Foundation
import os.log

protocol RestConvertible: URLRequestConvertible {
    func asRest(_ url: URL) -> URLRequest
}

extension RestConvertible where Self: Encodable {
    func asRest(_ url: URL) -> URLRequest {
        let data = try? asJsonData()
        
        Logger.debug(network: "RPC request:\n%{private}s") { String(data: data ?? Data(count: 0), encoding: .utf8) }
        return asURLRequest(url)
            .using(method: .post)
            .using(headers: [.contentType(.applicationJson)])
            .using(body: data)
    }
}
