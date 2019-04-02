import Foundation

protocol URLRequestConvertible {
    func asURLRequest(_ url: URL, timeout: TimeInterval) -> URLRequest
}

extension URLRequestConvertible {
    func asURLRequest(_ url: URL, timeout: TimeInterval) -> URLRequest {
        return URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)
    }
}
