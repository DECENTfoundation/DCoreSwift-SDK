import Foundation
import RxSwift

public final class TransactionApi: BaseApi {
    
    public func getRecentTransaction(byTrxId id: String) -> Single<ProcessedTransaction> {
        return GetRecentTransactionById(id: id).toCoreRequest(api.core)
    }

    public func getTransaction(byTrxId id: String) -> Single<ProcessedTransaction> {
        return GetTransactionById(id: id).toCoreRequest(api.core)
    }
    
    public func getTransaction(byBlockNum num: UInt64, trxInBlock: UInt64) -> Single<ProcessedTransaction> {
        return GetTransaction(blockNum: num, trxInBlock: trxInBlock).toCoreRequest(api.core)
    }

    public func getTransaction(byConfirmation conf: TransactionConfirmation) -> Single<ProcessedTransaction> {
        return getTransaction(byBlockNum: conf.blockNum, trxInBlock: conf.trxNum)
    }
    
    public func createTransaction(operations: [BaseOperation], expiration: Int? = nil) -> Single<Transaction> {
        return api.core.prepareTransaction(forOperations: operations, expiration: expiration ?? self.api.transactionExpiration)
    }
    
    public func createTransaction(operation: BaseOperation, expiration: Int? = nil) -> Single<Transaction> {
        return api.core.prepareTransaction(forOperations: [operation], expiration: expiration ?? self.api.transactionExpiration)
    }
    
    public func getTransactionHex(byTrx trx: Transaction) -> Single<String> {
        return GetTransactionHex(transaction: trx).toCoreRequest(api.core)
    }
    
    public func getProposedTransactions(byAccountId id: ChainObject) -> Single<AnyValue> {
        return  GetProposedTransactions(accountId: id).toCoreRequest(api.core)
    }
}
