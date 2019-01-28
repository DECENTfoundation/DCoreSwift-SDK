import Foundation
import RxSwift

public protocol BroadcastApi: BaseApi {
    func broadcast<Input>(_ trx: Transaction<Input>) -> Completable where Input: Operation
    func broadcast<Input>(using keypair: ECKeyPair,
                          operations: [Input],
                          expiration: Int?) -> Completable where Input: Operation
    func broadcast<Input>(using keypair: ECKeyPair, operation: Input, expiration: Int?) -> Completable where Input: Operation
    func broadcast<Input>(using keypair: String, operations: [Input], expiration: Int?) -> Completable where Input: Operation
    func broadcast<Input>(using keypair: String, operation: Input, expiration: Int?) -> Completable where Input: Operation
    func broadcast<Input>(withCallback trx: Transaction<Input>) -> Observable<TransactionConfirmation<Input>> where Input: Operation
    func broadcast<Input>(withCallback keypair: ECKeyPair,
                          operations: [Input],
                          expiration: Int?) -> Observable<TransactionConfirmation<Input>> where Input: Operation
    func broadcast<Input>(withCallback keypair: ECKeyPair,
                          operation: Input,
                          expiration: Int?) -> Observable<TransactionConfirmation<Input>> where Input: Operation
    func broadcast<Input>(withCallback keypair: String,
                          operations: [Input],
                          expiration: Int?) -> Observable<TransactionConfirmation<Input>> where Input: Operation
    func broadcast<Input>(withCallback keypair: String,
                          operation: Input,
                          expiration: Int?) -> Observable<TransactionConfirmation<Input>> where Input: Operation
    func broadcast<Input>(synchronous trx: Transaction<Input>) -> Single<TransactionConfirmation<Input>> where Input: Operation
}

extension BroadcastApi {
    public func broadcast<Input>(_ trx: Transaction<Input>) -> Completable where Input: Operation {
        return BroadcastTransaction(trx).base.toResponse(api.core).asCompletable()
    }
    
    public func broadcast<Input>(using keypair: ECKeyPair,
                                 operations: [Input],
                                 expiration: Int? = nil) -> Completable where Input: Operation {
        return api.transaction.create(transactionUsing: operations, expiration: expiration.or(self.api.transactionExpiration))
            .map { try $0.with(signature: keypair) }
            .flatMapCompletable { self.broadcast($0) }
    }
    
    public func broadcast<Input>(using keypair: ECKeyPair,
                                 operation: Input,
                                 expiration: Int? = nil) -> Completable where Input: Operation {
        return broadcast(using: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast<Input>(using keypair: String,
                                 operations: [Input],
                                 expiration: Int? = nil) -> Completable where Input: Operation {
        return Single.just(keypair.dcore.keyPair).flatMapCompletable {
            guard let kp = $0 else {
                return Completable.error(DCoreException.unexpected("Can't create keypair from \(keypair)"))
            }
            return self.broadcast(using: kp, operations: operations, expiration: expiration)
        }
    }
    
    public func broadcast<Input>(using keypair: String,
                                 operation: Input,
                                 expiration: Int? = nil) -> Completable where Input: Operation {
        return broadcast(using: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast<Input>(withCallback trx: Transaction<Input>) -> Observable<TransactionConfirmation<Input>> where Input: Operation {
        return BroadcastTransactionWithCallback(trx).base.toStreamResponse(api.core).single()
    }
    
    public func broadcast<Input>(withCallback keypair: ECKeyPair,
                                 operations: [Input],
                                 expiration: Int? = nil) -> Observable<TransactionConfirmation<Input>> where Input: Operation {
        return api.transaction.create(transactionUsing: operations, expiration: expiration.or(self.api.transactionExpiration))
            .map { try $0.with(signature: keypair) }
            .asObservable()
            .flatMap { self.broadcast(withCallback: $0) }
    }
    
    public func broadcast<Input>(withCallback keypair: ECKeyPair,
                                 operation: Input,
                                 expiration: Int? = nil) -> Observable<TransactionConfirmation<Input>> where Input: Operation {
        return broadcast(withCallback: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast<Input>(withCallback keypair: String,
                                 operations: [Input],
                                 expiration: Int? = nil) -> Observable<TransactionConfirmation<Input>> where Input: Operation {
        return Single.just(keypair.dcore.keyPair).asObservable().flatMap({ kp -> Observable<TransactionConfirmation<Input>> in
            guard let kp = kp else {
                return Observable.error(DCoreException.unexpected("Can't create keypair from \(keypair)"))
            }
            return self.broadcast(withCallback: kp, operations: operations, expiration: expiration)
        })
    }
    
    public func broadcast<Input>(withCallback keypair: String,
                                 operation: Input,
                                 expiration: Int? = nil) -> Observable<TransactionConfirmation<Input>> where Input: Operation {
        return broadcast(withCallback: keypair, operations: [operation], expiration: expiration)
    }
    
    public func broadcast<Input>(synchronous trx: Transaction<Input>) -> Single<TransactionConfirmation<Input>> where Input: Operation {
        return BroadcastTransactionSynchronous(trx).base.toResponse(api.core)
    }
}

extension ApiProvider: BroadcastApi {}
