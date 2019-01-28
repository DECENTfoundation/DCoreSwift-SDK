import Foundation
import BigInt

public struct Memo: Codable {
    
    public var from: Address?
    public var to: Address?
    public var message: String
    
    public let nonce: BigInt
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        to,
        message,
        nonce
    }

    public init(_ message: String,
                keyPair: ECKeyPair?,
                recipient: Address?,
                nonce: BigInt = CryptoUtils.generateNonce()
        ) throws {
        
        precondition(nonce.sign == .plus, "Nonce must be a positive number")
        
        self.from = keyPair?.address
        self.to = recipient
        self.message = try message.encrypt(keyPair, address: recipient, nonce: nonce)
        self.nonce = !recipient.isNil() ? nonce : 0
    }
}

extension Memo: CipherConvertible {
    public func decrypt(_ keyPair: ECKeyPair, address: Address? = nil, nonce: BigInt) throws -> Memo {
        var memo = self
        if from.isNil() || to.isNil() {
            memo.message = try self.message.decrypt(keyPair, address: address, nonce: nonce)
        } else if let from = from, from.publicKey == keyPair.publicKey {
            memo.message = try self.message.decrypt(keyPair, address: from, nonce: self.nonce)
        } else if let to = to, to.publicKey == keyPair.publicKey {
            memo.message = try self.message.decrypt(keyPair, address: to, nonce: self.nonce)
        } else {
            memo.message = ""
        }
        
        return memo
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
