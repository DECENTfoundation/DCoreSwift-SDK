import Foundation

protocol URLRequestConvertible {
    func toURLRequest<Value>(_ url: URL, method: HttpMethod, headers: [HttpHeader: Value], data: Data?, timeout: TimeInterval?) -> URLRequest
    func post<Value>(_ url: URL, headers: [HttpHeader: Value], data: Data?, timeout: TimeInterval?) -> URLRequest where Value: RawRepresentable
    func postJson(_ url: URL, timeout: TimeInterval?) -> URLRequest
    
    func toHttpBody() -> Data?
}

extension URLRequestConvertible {
    func toURLRequest<Value>(_ url: URL, method: HttpMethod, headers: [HttpHeader: Value], data: Data? = nil, timeout: TimeInterval?) -> URLRequest where Value: RawRepresentable {
        
        var request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: timeout ?? DCore.Constant.Api.timeout)
        request.httpMethod = method.rawValue
        request.httpBody = data
        
        // headers.forEach({ request.addValue($0.value.rawValue, forHTTPHeaderField: $0.key.rawValue) })
        
        return request
    }
    
    func post<Value>(_ url: URL, headers: [HttpHeader: Value], data: Data?, timeout: TimeInterval?) -> URLRequest {
        return toURLRequest(url, method: .post, headers: headers, data: data, timeout: timeout)
    }
    
    func postJson(_ url: URL, timeout: TimeInterval?) -> URLRequest {
        return post(url, headers: [.contentType: ContentType.applicationJson], data: toHttpBody(),timeout: timeout)
    }
}

extension URLRequestConvertible where Self: Encodable {
    func toHttpBody() -> Data? {
        return try? self.toJsonData()
    }
}
