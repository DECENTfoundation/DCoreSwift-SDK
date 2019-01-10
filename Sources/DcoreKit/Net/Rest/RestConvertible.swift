import Foundation

protocol RestConvertible: URLRequestConvertible {
    func asRest(_ url: URL) -> URLRequest
}

extension RestConvertible where Self: Encodable {
    func asRest(_ url: URL) -> URLRequest {
        return asURLRequest(url)
            .using(method: .post)
            .using(headers: [.contentType(.applicationJson)])
            .using(body: try? asJsonData())
    }
}
