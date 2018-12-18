import Foundation
import BigInt

public struct Memo: Codable {
    public var from: Address?
    public var to: Address?
    public let message: String
    public let nonce: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        to,
        message,
        nonce
    }
    
    public init(message: String) {
        self.message = (Data(count: 4) + message).toHex()
        self.nonce = 0
        self.from = nil
        self.to = nil
    }
    
    public init(message: String, keyPair: ECKeyPair, recipient: Address, nonce: BigInt?) {
        
        self.nonce = nonce ?? 0
        guard self.nonce.signum() > 0 else { preconditionFailure("nonce must be a positive number") }
        
        self.from = Address(fromKeyPair: keyPair)
        self.to = recipient
        self.message = message
        // val checksummed = Sha256Hash.hash(message.toByteArray()).copyOfRange(0, 4) + message.toByteArray()
        // val secret = keyPair.secret(recipient, this.nonce)
        // this.message = encryptAes(secret, checksummed).hex()
    }
}

extension Memo: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += from!
        data += to!
        data += nonce
        data += Data(hex: message)!
        return data
    }
}
