import Foundation

protocol URLRequestConvertible {
    func asURLRequest(_ url: URL) -> URLRequest
}

extension URLRequestConvertible {
    func asURLRequest(_ url: URL) -> URLRequest {
        return URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: DCore.Constant.timeout)
    }
}
