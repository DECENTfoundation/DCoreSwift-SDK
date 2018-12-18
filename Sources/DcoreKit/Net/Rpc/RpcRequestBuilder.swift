import Foundation

public struct RpcRequestBuilder<T> {
    
    private let base: BaseRequest<T>
    
    init(base: BaseRequest<T>) {
        self.base = base
    }
    
    public func toURLRequest(url: URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.addValue(ContentType.ApplicationJson.rawValue, forHTTPHeaderField: ContentType.Name)
        request.httpMethod = HttpMethod.post.rawValue
    
        return request
    }
}
