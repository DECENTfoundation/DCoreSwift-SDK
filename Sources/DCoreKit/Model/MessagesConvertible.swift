import Foundation

protocol MessagesConvertible {
    func asMessages(_ credentials: Credentials) throws -> [Message]
}

extension MessageResponse: MessagesConvertible {
    func asMessages(_ credentials: Credentials = Credentials.null) throws -> [Message] {
        return try receivers.map {
            try Message(id: id,
                    created: created,
                    sender: sender,
                    senderAddress: senderAddress,
                    receiver: $0.receiver,
                    receiverAddress: $0.receiverAddress,
                    message: $0.data,
                    nonce: $0.nonce
            ).decrypt(credentials)
        }
    }
}
