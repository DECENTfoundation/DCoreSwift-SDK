import Foundation

protocol URLRequestConvertible {
    func toURLRequest(_ url: URL) -> URLRequest
}

extension URLRequestConvertible {
    func toURLRequest(_ url: URL) -> URLRequest {
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: DCore.Constant.Api.timeout)
    }
}

