import Foundation
import RxSwift

public protocol TransactionApi: BaseApi {
    /**
     Get transaction for the given id.
     
     - Parameter id: Transaction id.
     
     - Throws: `DCoreException.Network.notFound`
     if transaction does not exist.
     
     - Returns: `ProcessedTransaction` if found.
     */
    func get(byId id: String) -> Single<ProcessedTransaction>
    
    /**
     Get applied transaction.
     
     - Parameter num: Block number.
     - Parameter position: Position of the transaction in block.
     
     - Throws: `DCoreException.Network.notFound`
     if transaction does not exist.
     
     - Returns: `ProcessedTransaction` if found.
     */
    func get(byBlockNum num: UInt64, positionInBlock position: UInt64) -> Single<ProcessedTransaction>
    
    /**
     Get applied transaction by confirmation.
     
     - Parameter conf: Transaction confirmation.
     
     - Throws: `DCoreException.Network.notFound`
     if transaction does not exist.
     
     - Returns: `ProcessedTransaction` if found.
     */
    func get(byConfirmation conf: TransactionConfirmation) -> Single<ProcessedTransaction>
    
    /**
     Get a hexdump of the serialized binary form of a transaction.
     
     - Parameter trx: Signed transaction.
     
     - Returns: Hexadecimal string.
     */
    func getHex(byTransaction trx: Transaction) -> Single<String>
    
    /**
     Get the set of proposed transactions relevant to the specified account id.
     
     - Parameter id: Account id as `AccountObjectId` or `String` format.
    
     - Throws: `DCoreException.Network.notFound`
     if transaction does not exist.
     
     - Returns: `ProcessedTransaction` if found.
     */
    func getAllProposed(byAccountId id: AccountObjectIdConvertible) -> Single<AnyValue>
    
    /**
     Create unsigned transaction.
     
     - Parameter operations: Operations to include in transaction.
     - Parameter expiration: Transaction expiration in seconds,
     after the expiry the transaction is removed from recent pool
     and will be dismissed if not included in DCore block,
     default `DCore.Constats.expiration`
     
     - Returns: Unsigned `Transaction`.
     */
    func create(_ operations: [Operation], expiration: Int?) -> Single<Transaction>
    
    /**
     Create unsigned transaction.
     
     - Parameter operation: Operation to include in transaction.
     - Parameter expiration: Transaction expiration in seconds,
     after the expiry the transaction is removed from recent pool
     and will be dismissed if not included in DCore block,
     default `DCore.Constats.expiration`
     
     - Returns: Unsigned `Transaction`.
     */
    func create(_ operation: Operation, expiration: Int?) -> Single<Transaction>
}

extension TransactionApi {
    public func get(byId id: String) -> Single<ProcessedTransaction> {
        return GetTransactionById(id).base.toResponse(api.core)
    }
    
    public func get(byBlockNum num: UInt64, positionInBlock: UInt64) -> Single<ProcessedTransaction> {
        return GetTransaction(num, trxInBlock: positionInBlock).base.toResponse(api.core)
    }
    
    public func get(byConfirmation conf: TransactionConfirmation) -> Single<ProcessedTransaction> {
        return get(byBlockNum: conf.blockNum, positionInBlock: conf.trxNum)
    }
    
    public func getHex(byTransaction trx: Transaction) -> Single<String> {
        return GetTransactionHex(trx).base.toResponse(api.core)
    }
    
    public func getAllProposed(byAccountId id: AccountObjectIdConvertible) -> Single<AnyValue> {
        return Single.deferred {
            return GetProposedTransactions(try id.asAccountObjectId()).base.toResponse(self.api.core)
        }
    }
    
    public func create(_ operations: [Operation], expiration: Int? = nil) -> Single<Transaction> {
        return api.core.prepare(operations, expiration: expiration.or(self.api.transactionExpiration))
    }
    
    public func create(_ operation: Operation, expiration: Int? = nil) -> Single<Transaction> {
        return api.core.prepare([operation], expiration: expiration.or(self.api.transactionExpiration))
    }
}

extension ApiProvider: TransactionApi {}
