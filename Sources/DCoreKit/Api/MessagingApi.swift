import Foundation
import RxSwift

public protocol MessagingApi: BaseApi {

    /**
     Get all messages by sender.

     - Parameter sender: Filter by sender account id,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.

     - Returns: `[Message]`.
     */
    func getAll(bySender sender: ChainObjectConvertible, limit: Int) -> Single<[Message]>

    /**
     Get all messages by receiver.

     - Parameter receiver: Filter by receiver account id,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.

     - Returns: `[Message]`.
     */
    func getAll(byReceiver receiver: ChainObjectConvertible, limit: Int) -> Single<[Message]>
    
    /**
     Get all messages decrypted by sender.
     
     - Parameter credentials: Account credenials,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.
     
     - Returns: `[Message]`.
     */
    func getAllSenderDecrypted(_ credentials: Credentials, limit: Int) -> Single<[Message]>
    
    /**
     Get all messages decrypted by receiver.
     
     - Parameter credentials: Account credenials,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.
     
     - Returns: `[Message]`.
     */
    func getAllReceiverDecrypted(_ credentials: Credentials, limit: Int) -> Single<[Message]>

    /**
     Get all messages responses.

     - Parameter sender: Filter by sender account id,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.

     - Returns: `[MessageResponse]`.
     */
    func getAllResponses(bySender sender: ChainObjectConvertible, limit: Int) -> Single<[MessageResponse]>

    /**
     Get all messages responses.

     - Parameter receiver: Filter by receiver account id,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.

     - Returns: `[MessageResponse]`.
     */
    func getAllResponses(byReceiver receiver: ChainObjectConvertible, limit: Int) -> Single<[MessageResponse]>

    /**
     Create message operation, send a message to one receiver.
     
     - Parameter to: receiver account id,
     as `ChainObject` or `String` format.
     - Parameter message: Message to send.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func createMessage(to: ChainObjectConvertible, message: String, credentials: Credentials) -> Single<SendMessageOperation>
    
    /**
     Create message operation, send messages to multiple receivers.
     
     - Parameter payloads: Pairs of receiver account id,
     as `ChainObject` or `String` format
     and message.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func createMessage(_ payloads: [Pair<ChainObjectConvertible, String>], credentials: Credentials) -> Single<SendMessageOperation>
    
    /**
     Send a message to one receiver.
     
     - Parameter to: receiver account id,
     as `ChainObject` or `String` format.
     - Parameter message: Message to send.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func send(to: ChainObjectConvertible, message: String, credentials: Credentials) -> Single<TransactionConfirmation>
    
    /**
     Create unencrypted message operation, send a message to one receiver.
     
     - Parameter to: receiver account id,
     as `ChainObject` or `String` format.
     - Parameter message: Message to send.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func createUnencryptedMessage(to: ChainObjectConvertible, message: String, credentials: Credentials) -> Single<SendMessageOperation>
    
    /**
     Create unencrypted message operation, send messages to multiple receivers.
     
     - Parameter payloads: Pairs of receiver account id,
     as `ChainObject` or `String` format
     and message.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func createUnencryptedMessage(_ payloads: [Pair<ChainObjectConvertible, String>], credentials: Credentials) -> Single<SendMessageOperation>
    
    /**
     Send unencrypted message to one receiver.
     
     - Parameter to: receiver account id,
     as `ChainObject` or `String` format.
     - Parameter message: Message to send.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func sendUnencrypted(to: ChainObjectConvertible, message: String, credentials: Credentials) -> Single<TransactionConfirmation>
}

extension MessagingApi {
    public func getAll(bySender sender: ChainObjectConvertible,
                       limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return getAll(sender, limit: limit)
    }

    public func getAll(byReceiver receiver: ChainObjectConvertible,
                       limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return getAll(receiver: receiver, limit: limit)
    }

    private func getAll(_ sender: ChainObjectConvertible? = nil,
                        receiver: ChainObjectConvertible? = nil,
                        limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return getAllResponses(sender, receiver: receiver, limit: limit)
            .map { responses in Array( responses.map { $0.asMessages() }.joined()) }
    }
    
    public func getAllSenderDecrypted(_ credentials: Credentials, limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return getAllResponses(credentials.accountId, limit: limit)
            .map { responses in Array(responses.map { $0.asMessages(decrypt: credentials) }.joined()) }
    }
    
    public func getAllReceiverDecrypted(_ credentials: Credentials, limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return getAllResponses(nil, receiver: credentials.accountId, limit: limit)
            .map { responses in Array(responses.map {$0.asMessages(decrypt: credentials) }.joined()) }
    }

    public func getAllResponses(bySender sender: ChainObjectConvertible,
                                limit: Int = DCore.Limits.messaging) -> Single<[MessageResponse]> {
        return getAllResponses(sender, limit: limit)
    }

    public func getAllResponses(byReceiver receiver: ChainObjectConvertible,
                                limit: Int = DCore.Limits.messaging) -> Single<[MessageResponse]> {
        return getAllResponses(receiver: receiver, limit: limit)
    }

    private func getAllResponses(_ sender: ChainObjectConvertible? = nil,
                                 receiver: ChainObjectConvertible? = nil,
                                 limit: Int = DCore.Limits.messaging) -> Single<[MessageResponse]> {
        return Single.deferred {
            return GetMessageObjects(try sender?.asChainObject(), receiver: try receiver?.asChainObject(), limit: limit)
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func createMessage(to: ChainObjectConvertible, message: String, credentials: Credentials) -> Single<SendMessageOperation> {
        return createMessage([Pair(to, message)], credentials: credentials)
    }
    
    public func createMessage(_ payloads: [Pair<ChainObjectConvertible, String>], credentials: Credentials) -> Single<SendMessageOperation> {
        return Single.deferred {
            let recipients = Single.zip(try payloads.map { self.api.account.get(byId: try $0.first.asChainObject()) })
            return Single
                .zip(self.api.account.get(byId: credentials.accountId), recipients)
                .map { (sender, recipients) in
                    let receivers = try recipients.enumerated().map { (offset, recipient) -> MessagePayloadReceiver in
                        let memo = try Memo(payloads[offset].second, credentials: credentials, recipient: recipient)
                        return MessagePayloadReceiver(to: recipient.id,
                                                      data: memo.message,
                                                      toAddress: recipient.options.memoKey,
                                                      nonce: memo.nonce)
                    }
                    guard let data = MessagePayload(sender.id, receivers: receivers, fromAddress: sender.options.memoKey).asJson() else {
                        throw DCoreException.network(.failEncode("Failed to encode message"))
                    }
                    return SendMessageOperation(data, payee: credentials.accountId)
            }
        }
    }
    
    public func send(to: ChainObjectConvertible, message: String, credentials: Credentials) -> Single<TransactionConfirmation> {
        return createMessage(to: to, message: message, credentials: credentials).flatMap {
            self.api.broadcast.broadcastWithCallback($0, keypair: credentials.keyPair)
        }
    }
    
    public func createUnencryptedMessage(to: ChainObjectConvertible, message: String, credentials: Credentials) -> Single<SendMessageOperation> {
        return createUnencryptedMessage([Pair(to, message)], credentials: credentials)
    }
    
    public func createUnencryptedMessage(_ payloads: [Pair<ChainObjectConvertible, String>], credentials: Credentials) -> Single<SendMessageOperation> {
        return Single.deferred {
            guard let data = try MessagePayload(credentials.accountId, messages: payloads).asJson() else {
                throw DCoreException.network(.failEncode("Failed to encode message"))
            }
            return Single.just(SendMessageOperation(data, payee: credentials.accountId))
        }
    }
    
    public func sendUnencrypted(to: ChainObjectConvertible, message: String, credentials: Credentials) -> Single<TransactionConfirmation> {
        return createUnencryptedMessage(to: to, message: message, credentials: credentials).flatMap {
            self.api.broadcast.broadcastWithCallback($0, keypair: credentials.keyPair)
        }
    }
    
}

extension ApiProvider: MessagingApi {}
