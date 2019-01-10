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
    
    public init(_ message: String) {
        self.message = (Data(count: 4) + message).toHex()
        self.nonce = 0
        self.from = nil
        self.to = nil
    }
    
    public init(_ message: String, keyPair: ECKeyPair, recipient: Address, nonce: BigInt = CryptoUtils.generateNonce()) {
        
        precondition(nonce.signum() > 0, "Nonce must be a positive number")
        
        self.nonce = nonce
        self.from = keyPair.address
        self.to = recipient
        
        let data = message.data(using: .ascii)!
        let checksumed = CryptoUtils.hash256(data).prefix(4) + data
        let secret = keyPair.secret(recipient, nonce: self.nonce)
        
        self.message = CryptoUtils.encrypt(secret, message: checksumed).toHex()
    }
}

extension Memo: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += from!
        data += to!
        data += nonce
        data += message.unhex()!
        return data
    }
}
