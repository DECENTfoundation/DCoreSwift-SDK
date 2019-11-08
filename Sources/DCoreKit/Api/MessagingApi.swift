import Foundation
import RxSwift

public protocol MessagingApi: BaseApi {
    
    /**
     Get all messages by ids.

     - Parameter ids: Filter by message ids,
     as `[MessagingObjectId]` or `[String]` format.

     - Returns: `[Message]`.
     */
    func getAll(byIds ids: [ObjectIdConvertible]) -> Single<[Message]>
    
    /**
     Get message by id.

     - Parameter id: Filter by message id,
     as `MessagingObjectId` or `String` format.

     - Returns: `Message`.
     */
    func get(byId id: ObjectIdConvertible) -> Single<Message>
    
    /**
     Get all messages by ids decrypted.
     
     - Parameter ids: Filter by message ids,
     as `[MessagingObjectId]` or `[String]` format.
     - Parameter credentials: Account credenials,
     as `ChainObject` or `String` format.

     - Returns: `[Message]`.
     */
    func getAllDecrypted(byIds ids: [ObjectIdConvertible], credentials: Credentials) -> Single<[Message]>
    
    /**
     Get message by id decrypted.
     
     - Parameter id: Filter by message id,
     as `MessagingObjectId` or `String` format.
     - Parameter credentials: Account credenials,
     as `ChainObject` or `String` format.

     - Returns: `Message`.
     */
    func getDecrypted(byId id: ObjectIdConvertible, credentials: Credentials) -> Single<Message>
    
    /**
     Find all messages by sender.

     - Parameter sender: Filter by sender account id,
     as `AccountObjectId` or `String` format.
     - Parameter limit: Max items to return.

     - Returns: `[Message]`.
     */
    func findAll(bySender sender: AccountObjectIdConvertible, limit: Int) -> Single<[Message]>

    /**
     Find all messages by receiver.

     - Parameter receiver: Filter by receiver account id,
     as `AccountObjectId` or `String` format.
     - Parameter limit: Max items to return.

     - Returns: `[Message]`.
     */
    
    func findAll(byReceiver receiver: AccountObjectIdConvertible, limit: Int) -> Single<[Message]>
    
    /**
     Find all messages decrypted by sender.
     
     - Parameter credentials: Account credenials,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.
     
     - Returns: `[Message]`.
     */
    func findAllSenderDecrypted(_ credentials: Credentials, limit: Int) -> Single<[Message]>
    
    /**
     Find all messages decrypted by receiver.
     
     - Parameter credentials: Account credenials,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.
     
     - Returns: `[Message]`.
     */
    func findAllReceiverDecrypted(_ credentials: Credentials, limit: Int) -> Single<[Message]>

    /**
     Find all messages responses.

     - Parameter sender: Filter by sender account id,
     as `AccountObjectId` or `String` format.
     - Parameter limit: Max items to return.

     - Returns: `[MessageResponse]`.
     */
    func findAllResponses(bySender sender: AccountObjectIdConvertible, limit: Int) -> Single<[MessageResponse]>

    /**
     Find all messages responses.

     - Parameter receiver: Filter by receiver account id,
     as `AccountObjectId` or `String` format.
     - Parameter limit: Max items to return.

     - Returns: `[MessageResponse]`.
     */
    func findAllResponses(byReceiver receiver: AccountObjectIdConvertible, limit: Int) -> Single<[MessageResponse]>

    /**
     Create message operation, send a message to one receiver.
     
     - Parameter to: receiver account id,
     as `AccountObjectId` or `String` format.
     - Parameter message: Message to send.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func createMessage(to: AccountObjectIdConvertible, message: String, credentials: Credentials) -> Single<SendMessageOperation>
    
    /**
     Create message operation, send messages to multiple receivers.
     
     - Parameter payloads: Pairs of receiver account id,
     as `AccountObjectId` or `String` format
     and message.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func createMessage(_ payloads: [Pair<AccountObjectIdConvertible, String>], credentials: Credentials) -> Single<SendMessageOperation>
    
    /**
     Send a message to one receiver.
     
     - Parameter to: receiver account id,
     as `AccountObjectId` or `String` format.
     - Parameter message: Message to send.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func send(to: AccountObjectIdConvertible, message: String, credentials: Credentials) -> Single<TransactionConfirmation>
    
    /**
     Create unencrypted message operation, send a message to one receiver.
     
     - Parameter to: receiver account id,
     as `AccountObjectId` or `String` format.
     - Parameter message: Message to send.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func createUnencryptedMessage(to: AccountObjectIdConvertible, message: String, credentials: Credentials) -> Single<SendMessageOperation>
    
    /**
     Create unencrypted message operation, send messages to multiple receivers.
     
     - Parameter payloads: Pairs of receiver account id,
     as `AccountObjectId` or `String` format
     and message.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func createUnencryptedMessage(_ payloads: [Pair<AccountObjectIdConvertible, String>], credentials: Credentials) -> Single<SendMessageOperation>
    
    /**
     Send unencrypted message to one receiver.
     
     - Parameter to: receiver account id,
     as `AccountObjectId` or `String` format.
     - Parameter message: Message to send.
     - Parameter credentials: Sender account credentials.
     
     - Returns: `SendMessageOperation`.
     */
    func sendUnencrypted(to: AccountObjectIdConvertible, message: String, credentials: Credentials) -> Single<TransactionConfirmation>
}

extension MessagingApi {
    public func getAll(byIds ids: [ObjectIdConvertible]) -> Single<[Message]> {
        return getAll(ids).map { responses in Array( responses.map { $0.asMessages() }.joined()) }
    }
    
    public func get(byId id: ObjectIdConvertible) -> Single<Message> {
        return getAll(byIds: [id]).map { try $0.first.orThrow(DCoreException.network(.notFound)) }
    }
    
    public func getAllDecrypted(byIds ids: [ObjectIdConvertible], credentials: Credentials) -> Single<[Message]> {
        return getAll(ids).map { responses in Array( responses.map { $0.asMessages(decrypt: credentials) }.joined()) }
    }
    
    public func getDecrypted(byId id: ObjectIdConvertible, credentials: Credentials) -> Single<Message> {
        return getAllDecrypted(byIds: [id], credentials: credentials).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }
    
    public func findAll(bySender sender: AccountObjectIdConvertible,
                        limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return findAll(sender, limit: limit)
    }

    public func findAll(byReceiver receiver: AccountObjectIdConvertible,
                        limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return findAll(receiver: receiver, limit: limit)
    }

    private func getAll(_ sender: AccountObjectIdConvertible? = nil,
                        receiver: AccountObjectIdConvertible? = nil,
                        limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return findAllResponses(sender, receiver: receiver, limit: limit)
            .map { responses in Array( responses.map { $0.asMessages() }.joined()) }
    }
    
    private func findAll(_ sender: AccountObjectIdConvertible? = nil,
                         receiver: AccountObjectIdConvertible? = nil,
                         limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return findAllResponses(sender, receiver: receiver, limit: limit)
            .map { responses in Array( responses.map { $0.asMessages() }.joined()) }
    }
    
    public func findAllSenderDecrypted(_ credentials: Credentials, limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return findAllResponses(credentials.accountId, limit: limit)
            .map { responses in Array(responses.map { $0.asMessages(decrypt: credentials) }.joined()) }
    }
    
    public func findAllReceiverDecrypted(_ credentials: Credentials, limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return findAllResponses(nil, receiver: credentials.accountId, limit: limit)
            .map { responses in Array(responses.map {$0.asMessages(decrypt: credentials) }.joined()) }
    }

    public func findAllResponses(bySender sender: AccountObjectIdConvertible,
                                 limit: Int = DCore.Limits.messaging) -> Single<[MessageResponse]> {
        return findAllResponses(sender, limit: limit)
    }

    public func findAllResponses(byReceiver receiver: AccountObjectIdConvertible,
                                 limit: Int = DCore.Limits.messaging) -> Single<[MessageResponse]> {
        return findAllResponses(receiver: receiver, limit: limit)
    }

    private func findAllResponses(_ sender: AccountObjectIdConvertible? = nil,
                                  receiver: AccountObjectIdConvertible? = nil,
                                  limit: Int = DCore.Limits.messaging) -> Single<[MessageResponse]> {
        return Single.deferred {
            return GetMessageObjects(
                try sender?.asAccountObjectId(), receiver: try receiver?.asAccountObjectId(), limit: limit)
                .base
                .toResponse(self.api.core)
        }
    }
    
    private func getAll(_ ids: [ObjectIdConvertible]) -> Single<[MessageResponse]> {
        return Single.deferred {
            return GetMessages(try ids.map { try $0.asObjectId() })
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func createMessage(to: AccountObjectIdConvertible, message: String, credentials: Credentials) -> Single<SendMessageOperation> {
        return createMessage([Pair(to, message)], credentials: credentials)
    }
    
    public func createMessage(_ payloads: [Pair<AccountObjectIdConvertible, String>], credentials: Credentials) -> Single<SendMessageOperation> {
        return Single.deferred {
            let recipients = Single.zip(try payloads.map { self.api.account.get(byId: $0.first) })
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
                    return SendMessageOperation(data, payer: credentials.accountId)
            }
        }
    }
    
    public func send(to: AccountObjectIdConvertible, message: String, credentials: Credentials) -> Single<TransactionConfirmation> {
        return createMessage(to: to, message: message, credentials: credentials).flatMap {
            self.api.broadcast.broadcastWithCallback($0, keypair: credentials.keyPair)
        }
    }
    
    public func createUnencryptedMessage(to: AccountObjectIdConvertible, message: String, credentials: Credentials) -> Single<SendMessageOperation> {
        return createUnencryptedMessage([Pair(to, message)], credentials: credentials)
    }
    
    public func createUnencryptedMessage(_ payloads: [Pair<AccountObjectIdConvertible, String>], credentials: Credentials) -> Single<SendMessageOperation> {
        return Single.deferred {
            guard let data = try MessagePayload(credentials.accountId, messages: payloads).asJson() else {
                throw DCoreException.network(.failEncode("Failed to encode message"))
            }
            return Single.just(SendMessageOperation(data, payer: credentials.accountId))
        }
    }
    
    public func sendUnencrypted(to: AccountObjectIdConvertible, message: String, credentials: Credentials) -> Single<TransactionConfirmation> {
        return createUnencryptedMessage(to: to, message: message, credentials: credentials).flatMap {
            self.api.broadcast.broadcastWithCallback($0, keypair: credentials.keyPair)
        }
    }
    
}

extension ApiProvider: MessagingApi {}
