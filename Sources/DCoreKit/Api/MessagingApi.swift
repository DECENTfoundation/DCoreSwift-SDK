import Foundation
import RxSwift

public protocol MessagingApi: BaseApi {
    
    /**
     Get all messages.
     
     - Parameter sender: Filter by sender account id,
     as `ChainObject` or `String` format.
     - Parameter receiver: Filter by receiver account id,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.
     
     - Returns: `[Message]`.
     */
    func getAll(_ sender: ChainObjectConvertible?,
                receiver: ChainObjectConvertible?,
                limit: Int) -> Single<[Message]>
    
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
     - Parameter receiver: Filter by receiver account id,
     as `ChainObject` or `String` format.
     - Parameter limit: Max items to return.
     
     - Returns: `[MessageResponse]`.
     */
    func getAllResponses(_ sender: ChainObjectConvertible?,
                         receiver: ChainObjectConvertible?,
                         limit: Int) -> Single<[MessageResponse]>
}

extension MessagingApi {
    public func getAll(_ sender: ChainObjectConvertible? = nil,
                       receiver: ChainObjectConvertible? = nil,
                       limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return getAllResponses(sender, receiver: receiver, limit: limit).map { responses in
            Array(try responses.map { try $0.asMessages() }.joined())
        }
    }
    
    public func getAllSenderDecrypted(_ credentials: Credentials, limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return getAllResponses(credentials.accountId, limit: limit).map { responses in
            Array(try responses.map { try $0.asMessages(credentials) }.joined())
        }
    }
    
    public func getAllReceiverDecrypted(_ credentials: Credentials, limit: Int = DCore.Limits.messaging) -> Single<[Message]> {
        return getAllResponses(nil, receiver: credentials.accountId, limit: limit).map { responses in
            Array(try responses.map { try $0.asMessages(credentials) }.joined())
        }
    }

    public func getAllResponses(_ sender: ChainObjectConvertible? = nil,
                                receiver: ChainObjectConvertible? = nil,
                                limit: Int = DCore.Limits.messaging) -> Single<[MessageResponse]> {
        return Single.deferred {
            return GetMessageObjects(try sender?.asChainObject(), receiver: try receiver?.asChainObject(), limit: limit)
                .base
                .toResponse(self.api.core)
        }
    }
    
    /*
    public func createMessage(_ payloads: [Pair<ChainObject, String>], credentials: Credentials) -> Single<SendMessageOperation> {
        return Single.deferred {
            let recipients = Single.zip(payloads.map { self.api.account.get(byId: $0.first) })
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
                    let data = MessagePayload(from: sender.id, receivers: receivers, fromAddress: sender.options.memoKey)
                    return SendMessageOperation(data.asJson(), payee: credentials.accountId)
            }
            
        }
    }*/
}

extension ApiProvider: MessagingApi {}
