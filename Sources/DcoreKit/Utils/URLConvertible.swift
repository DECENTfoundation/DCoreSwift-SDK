import Foundation

public protocol URLConvertible {
    func toURL() -> URL?
}

extension URL: URLConvertible {
    public func toURL() -> URL? {
        return self
    }
}

extension String: URLConvertible {
    public func toURL() -> URL? {
        return URL(string: self)
    }
}
