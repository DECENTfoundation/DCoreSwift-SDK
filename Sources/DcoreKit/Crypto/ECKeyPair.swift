import Foundation
import BigInt

public struct ECKeyPair {

    private static let compressed: Int = 4
    private static let compact: Int = 27
    
    let privateKey: PrivateKey
    let publicKey: PublicKey
    
    init(fromPrivateKey value: PrivateKey) {
        privateKey = value
        publicKey = value.toPublicKey()
    }
    
    init() {
        self.init(fromPrivateKey: PrivateKey(data: CryptoUtils.secureRandom()))
    }
    
    init(fromWif wif: String) throws {
        self.init(fromPrivateKey: try PrivateKey(fromWif: wif))
    }
    
    public func sign(_ message: Data) throws -> Data {
        let (recovery, compact) = try privateKey.sign(message)
        let signature = Data.of(recovery + ECKeyPair.compressed + ECKeyPair.compact) + compact
        
        if signature.canonicalSignature { throw ChainException.crypto(.failSigning) }
        return signature
    }
    
    public func secret(_ address: Address, nonce: BigInt) throws -> Data {
        let key = try address.publicKey.multiply(privateKey)
        return CryptoUtils.hash512(
            (nonce.magnitude.description + CryptoUtils.hash512(key).toHex()).asEncoded()
        )
    }
}

extension ECKeyPair: CustomStringConvertible {
    public var description: String {
        return privateKey.toWif()
    }
}

extension ECKeyPair: Equatable {
    public static func == (lhs: ECKeyPair, rhs: ECKeyPair) -> Bool {
        return lhs.privateKey == rhs.privateKey
    }
}

extension ECKeyPair {
    public var address: Address {
        return Address(fromPublicKey: publicKey.data)
    }
}

extension Chain where Base == String {
    public var keyPair: ECKeyPair? {
        return try? ECKeyPair(fromWif: self.base)
    }
}

extension Data {
    fileprivate var canonicalSignature: Bool {
        return (
            (self[0] & 0x80) != 0 ||
            (self[0] == 0) ||
            (self[1] & 0x80) != 0 ||
            (self[32] & 0x80) != 0 ||
            (self[32] == 0) ||
            (self[33] & 0x80) != 0
        )
    }
}
