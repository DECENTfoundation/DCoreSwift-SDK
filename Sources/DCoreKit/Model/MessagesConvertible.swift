import Foundation

protocol MessagesConvertible {
    func asMessages(decrypt credentials: Credentials) -> [Message]
}

extension MessageResponse: MessagesConvertible {
    func asMessages(decrypt credentials: Credentials = Credentials.null) -> [Message] {
        return receivers.map {
            Message(id: id,
                    created: created,
                    sender: sender,
                    senderAddress: senderAddress,
                    receiver: $0.receiver,
                    receiverAddress: $0.receiverAddress,
                    message: $0.data,
                    nonce: $0.nonce
            )
        }.compactMap { try? $0.decrypt(credentials) }
    }
}
