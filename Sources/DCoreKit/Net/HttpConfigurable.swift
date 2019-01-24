import Foundation

protocol HttpConfigurable {
    associatedtype Request
    
    func using(method value: Http.Method) -> Request
    func using(header value: Http.Header) -> Request
    func using(headers values: [Http.Header]) -> Request
    func using(body value: Data?) -> Request
}

extension HttpConfigurable {
    func using(header value: Http.Header) -> Request {
        return using(headers: [value])
    }
}
