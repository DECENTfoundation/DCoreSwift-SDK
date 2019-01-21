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
    
    public init(_ message: String = "") {
        self.message = (Data(count: 4) + message).toHex()
        self.nonce = 0
        self.from = nil
        self.to = nil
    }
    
    public init(_ message: String,
                keyPair: ECKeyPair,
                recipient: Address,
                nonce: BigInt = CryptoUtils.generateNonce()
        ) {
        
        precondition(nonce.sign == .plus, "Nonce must be a positive number")
        
        self.nonce = nonce
        self.from = keyPair.address
        self.to = recipient
        
        // todo - encrypt memo with derived key
        // let data = message.data(using: .ascii)!
        // let checksumed = CryptoUtils.hash256(data).prefix(4) + data
        // let secret = keyPair.secret(recipient, nonce: self.nonce)
        
        // CryptoUtils.encrypt(secret, message: checksumed).toHex()
        self.message = ""
    }
}

extension Memo: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += from.asData()
        data += to.asData()
        data += nonce.asData()
        data += message.unhex().asData()
       
        Logger.debug(crypto: "Memo binary: %{private}s", args: { "\(data.toHex()) (\(data)) [\(data.bytes)]"})
        return data
    }
}
