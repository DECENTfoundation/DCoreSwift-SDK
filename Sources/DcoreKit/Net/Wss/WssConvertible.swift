import Foundation

protocol WssConvertible {

    func with(id: UInt64, useCallback: Bool) -> Self
    func asWss(id: UInt64, useCallback: Bool) throws -> String
}

extension WssConvertible where Self: Encodable {
    func with(id: UInt64, useCallback: Bool) -> Self {
        fatalError("Not Implemented")
    }
    
    func asWss(id: UInt64, useCallback: Bool = false) throws -> String {
        return try with(id: id, useCallback: useCallback).asJson()
    }
}
