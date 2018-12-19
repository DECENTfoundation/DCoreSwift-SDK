import Foundation
import BigInt

public struct ECKeyPair {

    let privateKey: PrivateKey
    let publicKey: PublicKey
    
    init(fromPrivateKey value: PrivateKey) {
        self.privateKey = value
        self.publicKey = value.toPublicKey()
    }
    
    init() {
        self.init(fromPrivateKey: PrivateKey(data: CryptoUtils.secureRandom()))
    }
    
    init(fromWif wif: String) throws {
        self.init(fromPrivateKey: try PrivateKey(fromWif: wif))
    }
    
    public func sign(_ message: Data) throws -> Data {
        return try privateKey.sign(message)
    }
    
    public func secret(_ address: Address, nonce: BigInt) -> Data {
        // CryptoUtils.hash512(<#T##data: Data##Data#>)
        fatalError("")
    }
    
    public static func verify(signature: Data, message: Data, publicKey: Data) throws -> Bool {
        return try PublicKey(data: publicKey).verify(signature: signature, message: message)
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

extension String {
    public var keyPair: ECKeyPair? {
        return try? ECKeyPair(fromWif: self)
    }
}
