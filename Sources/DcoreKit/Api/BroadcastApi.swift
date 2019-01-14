import Foundation
import RxSwift

public final class BroadcastApi: BaseApi {

    public func broadcast(_ trx: Transaction) -> Completable {
        return BroadcastTransaction(trx).base.toResponse(api.core).asCompletable()
    }
    
    public func broadcast(using keypair: ECKeyPair,
                          operations: [BaseOperation],
                          expiration: Int? = nil) -> Completable {
        return api.transaction.createTransaction(operations, expiration: expiration ?? self.api.transactionExpiration)
            .map { try $0.with(signature: keypair) }
            .flatMapCompletable { [unowned self] in self.broadcast($0) }
    }
    
    public func broadcast(using keypair: ECKeyPair, operation: BaseOperation, expiration: Int? = nil) -> Completable {
        return broadcast(using: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast(using keypair: String, operations: [BaseOperation], expiration: Int? = nil) -> Completable {
        return Single.just(keypair.chain.keyPair).flatMapCompletable { [unowned self] in
            guard let kp = $0 else {
                return Completable.error(ChainException.unexpected("Can't create keypair from \(keypair)"))
            }
            return self.broadcast(using: kp, operations: operations, expiration: expiration)
        }
    }
    
    public func broadcast(using keypair: String, operation: BaseOperation, expiration: Int? = nil) -> Completable {
        return broadcast(using: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast(withCallback trx: Transaction) -> Observable<TransactionConfirmation> {
        return BroadcastTransactionWithCallback(trx).base.toStreamResponse(api.core).single()
    }
    
    public func broadcast(withCallback keypair: ECKeyPair,
                          operations: [BaseOperation],
                          expiration: Int? = nil) -> Observable<TransactionConfirmation> {
        return api.transaction.createTransaction(operations, expiration: expiration ?? self.api.transactionExpiration)
            .map { try $0.with(signature: keypair) }
            .asObservable()
            .flatMap { [unowned self] in self.broadcast(withCallback: $0) }
    }
    
    public func broadcast(withCallback keypair: ECKeyPair,
                          operation: BaseOperation,
                          expiration: Int? = nil) -> Observable<TransactionConfirmation> {
        return broadcast(withCallback: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast(withCallback keypair: String,
                          operations: [BaseOperation],
                          expiration: Int? = nil) -> Observable<TransactionConfirmation> {
        return Single.just(keypair.chain.keyPair).asObservable().flatMap({ kp -> Observable<TransactionConfirmation> in
            guard let kp = kp else {
                return Observable.error(ChainException.unexpected("Can't create keypair from \(keypair)"))
            }
            return self.broadcast(withCallback: kp, operations: operations, expiration: expiration)
        })
    }
    
    public func broadcast(withCallback keypair: String,
                          operation: BaseOperation,
                          expiration: Int? = nil) -> Observable<TransactionConfirmation> {
        return broadcast(withCallback: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast(synchronous trx: Transaction) -> Single<TransactionConfirmation> {
        return BroadcastTransactionSynchronous(trx).base.toResponse(api.core)
    }
}
