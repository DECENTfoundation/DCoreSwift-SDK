import Foundation
import RxSwift

public protocol TransactionApi: BaseApi {
    func getRecentTransaction(byTrxId id: String) -> Single<ProcessedTransaction>
    func getTransaction(byTrxId id: String) -> Single<ProcessedTransaction>
    func getTransaction(byBlockNum num: UInt64, trxInBlock: UInt64) -> Single<ProcessedTransaction>
    func getTransaction(byConfirmation conf: TransactionConfirmation) -> Single<ProcessedTransaction>
    func createTransaction(_ operations: [BaseOperation], expiration: Int?) -> Single<Transaction>
    func createTransaction(_ operation: BaseOperation, expiration: Int?) -> Single<Transaction>
    func getTransactionHex(byTrx trx: Transaction) -> Single<String>
    func getProposedTransactions(byAccountId id: ChainObject) -> Single<AnyValue>
}

extension TransactionApi {
    public func getRecentTransaction(byTrxId id: String) -> Single<ProcessedTransaction> {
        return GetRecentTransactionById(id).base.toResponse(api.core)
    }
    
    public func getTransaction(byTrxId id: String) -> Single<ProcessedTransaction> {
        return GetTransactionById(id).base.toResponse(api.core)
    }
    
    public func getTransaction(byBlockNum num: UInt64, trxInBlock: UInt64) -> Single<ProcessedTransaction> {
        return GetTransaction(num, trxInBlock: trxInBlock).base.toResponse(api.core)
    }
    
    public func getTransaction(byConfirmation conf: TransactionConfirmation) -> Single<ProcessedTransaction> {
        return getTransaction(byBlockNum: conf.blockNum, trxInBlock: conf.trxNum)
    }
    
    public func createTransaction(_ operations: [BaseOperation], expiration: Int? = nil) -> Single<Transaction> {
        return api.core.prepareTransaction(forOperations: operations,
                                           expiration: expiration ?? self.api.transactionExpiration)
    }
    
    public func createTransaction(_ operation: BaseOperation, expiration: Int? = nil) -> Single<Transaction> {
        return api.core.prepareTransaction(forOperations: [operation],
                                           expiration: expiration ?? self.api.transactionExpiration)
    }
    
    public func getTransactionHex(byTrx trx: Transaction) -> Single<String> {
        return GetTransactionHex(trx).base.toResponse(api.core)
    }
    
    public func getProposedTransactions(byAccountId id: ChainObject) -> Single<AnyValue> {
        return  GetProposedTransactions(id).base.toResponse(api.core)
    }
}

extension ApiProvider: TransactionApi {}
