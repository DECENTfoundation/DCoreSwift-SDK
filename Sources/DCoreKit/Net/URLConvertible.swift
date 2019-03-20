import Foundation

public protocol URLConvertible {
    func asURL() -> URL?
}

extension URLConvertible {
    func asURI(_ validate: ((String) -> Bool)? = nil) throws -> String {
        let validator = validate.or({ _ in true })
        guard let uri = asURL()?.absoluteString, validator(uri) else {
            throw DCoreException.unexpected("Value \(self) could not be converted to uri")
        }
        return uri
    }
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
