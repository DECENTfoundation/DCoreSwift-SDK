import Foundation

public protocol URLConvertible {
    func asURL() -> URL?
}

extension URL: URLConvertible {
    public func asURL() -> URL? {
        return self
    }
}

extension String: URLConvertible {
    public func asURL() -> URL? {
        return URL(string: self)
    }
}
