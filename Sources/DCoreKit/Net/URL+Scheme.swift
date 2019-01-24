import Foundation

extension URL: SchemeConvertible {
    public var type: Scheme {
        guard let val = scheme else { return .unknown }
        return Scheme(rawValue: val) ?? .unknown
    }
}
