import Foundation

public protocol ECKeyPairConvertible {
    func asECKeyPair() throws -> ECKeyPair
}

extension ECKeyPair: ECKeyPairConvertible {
    public func asECKeyPair() throws -> ECKeyPair {
        return self
    }
}

extension String: ECKeyPairConvertible {
    public func asECKeyPair() throws -> ECKeyPair {
        return try dcore.keyPair.orThrow(
            DCoreException.unexpected("WIF invalid format")
        )
    }
}
