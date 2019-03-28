import Foundation

public protocol ChainObjectConvertible {
    func asChainObject() throws -> ChainObject
}

extension ChainObject: ChainObjectConvertible {
    public func asChainObject() throws -> ChainObject {
        return self
    }
}

extension String: ChainObjectConvertible {
    public func asChainObject() throws -> ChainObject {
        return try dcore.chainObject.orThrow(
            DCoreException.unexpected("Chain object invalid format")
        )
    }
}
