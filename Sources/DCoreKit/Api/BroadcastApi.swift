import Foundation
import RxSwift

public protocol BroadcastApi: BaseApi {
    /**
     Broadcast transaction to DCore blockchain.
     
     - Parameter transaction: Transaction to broadcast.
     */
    func broadcast(_ transaction: Transaction) -> Completable
    
    /**
     Broadcast transaction to DCore blockchain.
     
     - Parameter keypair: Private key.
     - Parameter operations: Operations to be submitted to DCore.
     - Parameter expiration: Transaction expiration in seconds,
     after the expiry the transaction is removed from recent pool
     and will be dismissed if not included in DCore block
     */
    func broadcast(_ operations: [Operation],
                   keypair: ECKeyPairConvertible,
                   expiration: Int?) -> Completable
    
    /**
     Broadcast transaction to DCore blockchain.
     
     - Parameter keypair: Private key.
     - Parameter operation: Operation to be submitted to DCore.
     - Parameter expiration: Transaction expiration in seconds,
     after the expiry the transaction is removed from recent pool
     and will be dismissed if not included in DCore block
     */
    func broadcast(_ operation: Operation,
                   keypair: ECKeyPairConvertible,
                   expiration: Int?) -> Completable
    
    /**
     Broadcast transaction to DCore blockchain with callback.
     
     - Parameter transaction: Transaction to broadcast.
     
     - Returns: `TransactionConfirmation`.
     */
    func broadcastWithCallback(_ transaction: Transaction) -> Single<TransactionConfirmation>
    
    /**
     Broadcast transaction to DCore blockchain with callback.
     
     - Parameter keypair: Private key.
     - Parameter operations: Operations to be submitted to DCore.
     - Parameter expiration: Transaction expiration in seconds,
     after the expiry the transaction is removed from recent pool
     and will be dismissed if not included in DCore block
     
     - Returns: `TransactionConfirmation`.
     */
    func broadcastWithCallback(_ operations: [Operation],
                               keypair: ECKeyPairConvertible,
                               expiration: Int?) -> Single<TransactionConfirmation>
    
    /**
     Broadcast transaction to DCore blockchain with callback.
     
     - Parameter keypair: Private key.
     - Parameter operation: Operation to be submitted to DCore.
     - Parameter expiration: Transaction expiration in seconds,
     after the expiry the transaction is removed from recent pool
     and will be dismissed if not included in DCore block
     
     - Returns: `TransactionConfirmation`.
     */
    func broadcastWithCallback(_ operation: Operation,
                               keypair: ECKeyPairConvertible,
                               expiration: Int?) -> Single<TransactionConfirmation>
    
    /**
     Broadcast transaction to DCore blockchain.
     
     - Parameter transaction: Transaction to broadcast.
     
     - Returns: `TransactionConfirmation`.
     */
    func broadcastSynchronous(_ transaction: Transaction) -> Single<TransactionConfirmation>
}

extension BroadcastApi {
    public func broadcast(_ transaction: Transaction) -> Completable {
        return BroadcastTransaction(transaction).base.toResponse(api.core).asCompletable()
    }
    
    public func broadcast(_ operations: [Operation],
                          keypair: ECKeyPairConvertible,
                          expiration: Int? = nil) -> Completable {
        return api.transaction.create(operations, expiration: expiration.or(self.api.transactionExpiration))
            .map { try $0.with(signature: try keypair.asECKeyPair()) }
            .flatMapCompletable { self.broadcast($0) }
    }
    
    public func broadcast(_ operation: Operation,
                          keypair: ECKeyPairConvertible,
                          expiration: Int? = nil) -> Completable {
        return broadcast([operation], keypair: keypair, expiration: expiration)
    }
    
    public func broadcastWithCallback(_ transaction: Transaction) -> Single<TransactionConfirmation> {
        return BroadcastTransactionWithCallback(transaction).base.toStreamResponse(api.core).firstOrError()
    }
    
    public func broadcastWithCallback(_ operations: [Operation],
                                      keypair: ECKeyPairConvertible,
                                      expiration: Int? = nil) -> Single<TransactionConfirmation> {
        return api.transaction.create(operations, expiration: expiration.or(self.api.transactionExpiration))
            .map { try $0.with(signature: try keypair.asECKeyPair()) }
            .flatMap { self.broadcastWithCallback($0) }
    }
    
    public func broadcastWithCallback(_ operation: Operation,
                                      keypair: ECKeyPairConvertible,
                                      expiration: Int? = nil) -> Single<TransactionConfirmation> {
        return broadcastWithCallback([operation], keypair: keypair, expiration: expiration)
    }
   
    public func broadcastSynchronous(_ transaction: Transaction) -> Single<TransactionConfirmation> {
        return BroadcastTransactionSynchronous(transaction).base.toResponse(api.core)
    }
}

extension ApiProvider: BroadcastApi {}
