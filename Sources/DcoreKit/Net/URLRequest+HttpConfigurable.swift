import Foundation

extension URLRequest: HttpConfigurable {
    typealias Request = URLRequest
    
    func using(method value: Http.Method) -> URLRequest {
        var req = self
        req.httpMethod = value.rawValue
        
        return req
    }
    
    func using(headers values: [Http.Header]) -> URLRequest {
        var req = self
        values.forEach {
            switch $0 {
            case .field(let field): req.addValue("", forHTTPHeaderField: field)
            case .fieldPair(let field, let value): req.addValue(value, forHTTPHeaderField: field)
            }
        }

        return req
    }
    
    func using(body value: Data?) -> URLRequest {
        var req = self
        req.httpBody = value
        
        return req
    }
}
