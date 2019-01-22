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
        self.message = (Data(count: 4) + message.asEncoded()).toHex()
        self.nonce = 0
        self.from = nil
        self.to = nil
    }
    
    public init(_ message: String,
                keyPair: ECKeyPair,
                recipient: Address,
                nonce: BigInt = CryptoUtils.generateNonce()
        ) throws {
        
        precondition(nonce.sign == .plus, "Nonce must be a positive number")
        
        self.nonce = nonce
        self.from = keyPair.address
        self.to = recipient
        
        let checksumed  = CryptoUtils.hash256(message.asEncoded()).prefix(4) + message.asEncoded()
        let secret = try keyPair.secret(recipient, nonce: nonce)
        
        self.message = try CryptoUtils.encrypt(using: secret, input: checksumed).toHex()
    }
}

extension Memo: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += from.asData()
        data += to.asData()
        data += UInt64(nonce).littleEndian
        data += message.unhex().asData()
        Logger.debug(crypto: "Memo binary: %{private}s", args: { "\(data.toHex()) (\(data)) \(data.bytes)"})
        return data
    }
}
