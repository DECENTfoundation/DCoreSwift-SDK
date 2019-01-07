import Foundation

protocol RpcRequestConvertible: URLRequestConvertible {
    func toPostJson(_ url: URL) -> URLRequest
    func toPostJson(_ url: URL, body: Data?) -> URLRequest
}

extension RpcRequestConvertible {
    func toPostJson(_ url: URL) -> URLRequest {
        fatalError("Object does not conforms encodable, please add it or override this method")
    }
    
    func toPostJson(_ url: URL, body: Data?) -> URLRequest {
        return toURLRequest(url)
            .using(method: .post)
            .using(headers: [.contentType(.applicationJson)])
            .using(body: body)
    }
}


extension RpcRequestConvertible where Self: Encodable {
    func toPostJson(_ url: URL) -> URLRequest {
        return toPostJson(url, body: try? toJsonData())
    }
}
