import Foundation
import RxSwift

public protocol BroadcastApi: BaseApi {
    func broadcast(_ trx: Transaction) -> Completable
    func broadcast(using keypair: ECKeyPair,
                   operations: [Operation],
                   expiration: Int?) -> Completable
    func broadcast(using keypair: ECKeyPair, operation: Operation, expiration: Int?) -> Completable
    func broadcast(using keypair: String, operations: [Operation], expiration: Int?) -> Completable
    func broadcast(using keypair: String, operation: Operation, expiration: Int?) -> Completable
    func broadcast(withCallback trx: Transaction) -> Single<TransactionConfirmation>
    func broadcast(withCallback keypair: ECKeyPair,
                   operations: [Operation],
                   expiration: Int?) -> Single<TransactionConfirmation>
    func broadcast(withCallback keypair: ECKeyPair,
                   operation: Operation,
                   expiration: Int?) -> Single<TransactionConfirmation>
    func broadcast(withCallback keypair: String,
                   operations: [Operation],
                   expiration: Int?) -> Single<TransactionConfirmation>
    func broadcast(withCallback keypair: String,
                   operation: Operation,
                   expiration: Int?) -> Single<TransactionConfirmation>
    func broadcast(synchronous trx: Transaction) -> Single<TransactionConfirmation>
}

extension BroadcastApi {
    public func broadcast(_ trx: Transaction) -> Completable {
        return BroadcastTransaction(trx).base.toResponse(api.core).asCompletable()
    }
    
    public func broadcast(using keypair: ECKeyPair,
                          operations: [Operation],
                          expiration: Int? = nil) -> Completable {
        return api.transaction.create(operations, expiration: expiration.or(self.api.transactionExpiration))
            .map { try $0.with(signature: keypair) }
            .flatMapCompletable { self.broadcast($0) }
    }
    
    public func broadcast(using keypair: ECKeyPair,
                          operation: Operation,
                          expiration: Int? = nil) -> Completable {
        return broadcast(using: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast(using keypair: String,
                          operations: [Operation],
                          expiration: Int? = nil) -> Completable {
        return Single.just(keypair.dcore.keyPair).flatMapCompletable {
            guard let kp = $0 else {
                return Completable.error(DCoreException.unexpected("Can't create keypair from \(keypair)"))
            }
            return self.broadcast(using: kp, operations: operations, expiration: expiration)
        }
    }
    
    public func broadcast(using keypair: String,
                          operation: Operation,
                          expiration: Int? = nil) -> Completable {
        return broadcast(using: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast(withCallback trx: Transaction) -> Single<TransactionConfirmation> {
        return BroadcastTransactionWithCallback(trx).base.toStreamResponse(api.core).firstOrError()
    }
    
    public func broadcast(withCallback keypair: ECKeyPair,
                          operations: [Operation],
                          expiration: Int? = nil) -> Single<TransactionConfirmation> {
        return api.transaction.create(operations, expiration: expiration.or(self.api.transactionExpiration))
            .map { try $0.with(signature: keypair) }
            .flatMap { self.broadcast(withCallback: $0) }
    }
    
    public func broadcast(withCallback keypair: ECKeyPair,
                          operation: Operation,
                          expiration: Int? = nil) -> Single<TransactionConfirmation> {
        return broadcast(withCallback: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast(withCallback keypair: String,
                          operations: [Operation],
                          expiration: Int? = nil) -> Single<TransactionConfirmation> {
        return Single.just(keypair.dcore.keyPair).flatMap({ kp -> Single<TransactionConfirmation> in
            guard let kp = kp else {
                return Single.error(DCoreException.unexpected("Can't create keypair from \(keypair)"))
            }
            return self.broadcast(withCallback: kp, operations: operations, expiration: expiration)
        })
    }
    
    public func broadcast(withCallback keypair: String,
                          operation: Operation,
                          expiration: Int? = nil) -> Single<TransactionConfirmation> {
        return broadcast(withCallback: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast(synchronous trx: Transaction) -> Single<TransactionConfirmation> {
        return BroadcastTransactionSynchronous(trx).base.toResponse(api.core)
    }
}

extension ApiProvider: BroadcastApi {}
