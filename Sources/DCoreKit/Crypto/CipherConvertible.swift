import Foundation
import BigInt

public typealias CipherCodable = CipherConvertible & Codable

public protocol CipherConvertible {
    func decrypt(_ keyPair: ECKeyPair, address: Address?, nonce: BigInt) throws -> Self
    func encrypt(_ keyPair: ECKeyPair?, address: Address?, nonce: BigInt) throws -> Self
}

extension CipherConvertible {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> Self {
        throw DCoreException.crypto(.notSupported)
    }
    
    public func encrypt(_ keyPair: ECKeyPair?, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> Self {
        throw DCoreException.crypto(.notSupported)
    }
}

extension CipherConvertible where Self == String {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> Self {
        guard let address = address, let checksumed = unhex() else {
            return dropFirst(8).unhex().or(.empty).to(type: String.self)
        }
        
        let secret = try keyPair.secret(address, nonce: nonce)
        let result = try CryptoUtils.decrypt(secret, checksumInput: checksumed)
    
        return result.to(type: String.self)
    }
    
    public func encrypt(_ keyPair: ECKeyPair?, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> Self {
        guard let keyPair = keyPair, let address = address else {
            return (Data(count: 4) + asEncoded()).toHex()
        }
        
        let secret = try keyPair.secret(address, nonce: nonce)
        let result = try CryptoUtils.encrypt(secret, checksumInput: asEncoded())
        
        return result.toHex()
    }
}

extension String: CipherConvertible {}
