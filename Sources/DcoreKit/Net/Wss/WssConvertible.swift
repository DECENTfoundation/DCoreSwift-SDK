import Foundation

protocol WssConvertible {

    func with(callback id: UInt64) -> Self
    func asWss(callback id: UInt64) throws -> String
}

extension WssConvertible where Self: Encodable {
    func asWss(callback id: UInt64) throws -> String {
        return try with(callback: id).asJson()
    }
}
