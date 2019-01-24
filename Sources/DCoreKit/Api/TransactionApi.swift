import Foundation
import RxSwift

public protocol TransactionApi: BaseApi {
    func getRecentTransaction<Input>(byTrxId id: String) -> Single<ProcessedTransaction<Input>> where Input: Operation
    func getTransaction<Input>(byTrxId id: String) -> Single<ProcessedTransaction<Input>> where Input: Operation
    func getTransaction<Input>(byBlockNum num: UInt64, trxInBlock: UInt64) -> Single<ProcessedTransaction<Input>> where Input: Operation
    func getTransaction<Input>(byConfirmation conf: TransactionConfirmation<Input>) -> Single<ProcessedTransaction<Input>> where Input: Operation
    func create<Input>(transactionUsing operations: [Input], expiration: Int?) -> Single<Transaction<Input>> where Input: Operation
    func create<Input>(transactionUsing operation: Input, expiration: Int?) -> Single<Transaction<Input>> where Input: Operation
    func getTransactionHex<Input>(byTrx trx: Transaction<Input>) -> Single<String> where Input: Operation
    func getProposedTransactions(byAccountId id: ChainObject) -> Single<AnyValue>
}

extension TransactionApi {
    public func getRecentTransaction<Input>(byTrxId id: String) -> Single<ProcessedTransaction<Input>> where Input: Operation {
        return GetRecentTransactionById(id).base.toResponse(api.core)
    }
    
    public func getTransaction<Input>(byTrxId id: String) -> Single<ProcessedTransaction<Input>> where Input: Operation {
        return GetTransactionById(id).base.toResponse(api.core)
    }
    
    public func getTransaction<Input>(byBlockNum num: UInt64, trxInBlock: UInt64) -> Single<ProcessedTransaction<Input>> where Input: Operation {
        return GetTransaction(num, trxInBlock: trxInBlock).base.toResponse(api.core)
    }
    
    public func getTransaction<Input>(byConfirmation conf: TransactionConfirmation<Input>) -> Single<ProcessedTransaction<Input>> where Input: Operation {
        return getTransaction(byBlockNum: conf.blockNum, trxInBlock: conf.trxNum)
    }
    
    public func create<Input>(transactionUsing operations: [Input],
                              expiration: Int? = nil) -> Single<Transaction<Input>> where Input: Operation {
        return api.core.prepare(transactionUsing: operations,
                                expiration: expiration.or(self.api.transactionExpiration))
    }
    
    public func create<Input>(transactionUsing operation: Input,
                              expiration: Int? = nil) -> Single<Transaction<Input>> where Input: Operation {
        return api.core.prepare(transactionUsing: [operation],
                                expiration: expiration.or(self.api.transactionExpiration))
    }
    
    public func getTransactionHex<Input>(byTrx trx: Transaction<Input>) -> Single<String> where Input: Operation {
        return GetTransactionHex(trx).base.toResponse(api.core)
    }
    
    public func getProposedTransactions(byAccountId id: ChainObject) -> Single<AnyValue> {
        return  GetProposedTransactions(id).base.toResponse(api.core)
    }
}

extension ApiProvider: TransactionApi {}
