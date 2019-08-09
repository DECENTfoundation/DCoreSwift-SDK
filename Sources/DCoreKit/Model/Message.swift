import Foundation
import BigInt

public struct Message {
    public let id: ChainObject
    public let created: Date
    public let sender: ChainObject
    public var senderAddress: Address?
    public let receiver: ChainObject
    public var receiverAddress: Address?
    public var message: String
    public var nonce: BigInt = 0
    public var encrypted: Bool { return !senderAddress.isEmptyAddress() && !receiverAddress.isEmptyAddress() }
}

extension Message: CipherConvertible {
    public func decrypt(_ credentials: Credentials, address: Address? = nil, nonce: BigInt = CryptoUtils.generateNonce()) throws -> Message {
        guard let senderAddress = senderAddress, let receiverAddress = receiverAddress, encrypted else {
            return self
        }
        return try decrypt(credentials.keyPair, address: credentials.accountId == sender ? receiverAddress : senderAddress, nonce: self.nonce)
    }
    
    public func decrypt(_ keyPair: ECKeyPair, address: Address?, nonce: BigInt = CryptoUtils.generateNonce()) throws -> Message {
        var container = self
        container.message = try message.decrypt(keyPair, address: address, nonce: nonce)
        
        return container
    }
}

public struct MessageResponse: Codable {
    public let id: ChainObject
    public let created: Date
    public let sender: ChainObject
    public var senderAddress: Address?
    public let receivers: [MessageReceiver]
    public let text: String
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        created,
        sender,
        senderAddress = "sender_pubkey",
        receivers = "receivers_data",
        text
    }
}

public struct MessageReceiver: Codable {
    public let receiver: ChainObject
    public var receiverAddress: Address?
    public let nonce: BigInt
    public let data: String
    
    private enum CodingKeys: String, CodingKey {
        case
        receiver,
        receiverAddress = "receiver_pubkey",
        nonce,
        data
    }
}

public struct MessagePayload: Codable {
    public let from: ChainObject
    public let receivers: [MessagePayloadReceiver]
    public var fromAddress: Address?
    
    init(_ from: ChainObject, receivers: [MessagePayloadReceiver], fromAddress: Address?) {
        self.from = from
        self.receivers = receivers
        self.fromAddress = fromAddress
    }
    
    init(_ from: ChainObject, messages: [Pair<ChainObjectConvertible, String>]) throws {
        self.from = from
        self.receivers = try messages.map {
            MessagePayloadReceiver(to: try $0.first.asChainObject(), data: try Memo($0.second).message, toAddress: nil, nonce: nil)
        }

    }
    
    private enum CodingKeys: String, CodingKey {
        case
        from,
        receivers = "receivers_data",
        fromAddress = "pub_from"
    }
}

public struct MessagePayloadReceiver: Codable {
    public let to: ChainObject
    public let data: String
    public var toAddress: Address?
    public var nonce: BigInt?
    
    private enum CodingKeys: String, CodingKey {
        case
        to,
        data,
        toAddress = "pub_to",
        nonce
    }
}

private extension Optional where Wrapped == Address {
    func isEmptyAddress() -> Bool {
        return isNil() || self?.publicKey.data.allSatisfy { $0 == 0x00 } ?? true
    }
}
