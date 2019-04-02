import Foundation

protocol RestConvertible: URLRequestConvertible {
    func asRest(_ url: URL, timeout: TimeInterval) -> URLRequest
}

extension RestConvertible where Self: Encodable {
    func asRest(_ url: URL, timeout: TimeInterval) -> URLRequest {
        let data = try? asJsonData()
        
        DCore.Logger.debug(network: "RPC rest request:\n%{private}s") {
            String(data: data.or(Data.empty), encoding: .utf8)
        }
        return asURLRequest(url, timeout: timeout)
            .using(method: .post)
            .using(headers: [.contentType(.applicationJson)])
            .using(body: data)
    }
}
