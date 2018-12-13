import Foundation
import RxSwift

public class HistoryApi: BaseApi {
    
    public func getAccountHistory(byAccountId id: ChainObject,
                                  startId: ChainObject = ObjectType.OPERATION_HISTORY_OBJECT.genericId,
                                  stopId: ChainObject = ObjectType.OPERATION_HISTORY_OBJECT.genericId,
                                  limit: Int = 100) -> Single<[OperationHistory]> {
        
        return GetAccountHistory(accountId: id, stopId: stopId, limit: limit, startId: startId).toRequest(core: self.api.core)
    }
    
    public func getAccountHistoryRelative(byAccountId id: ChainObject,
                                          start: Int = 0,
                                          limit: Int = 100) -> Single<[OperationHistory]> {
    
        return GetRelativeAccountHistory(accountId: id, stop: 0, limit: limit, start: start).toRequest(core: self.api.core)
    }
    
    public func search(accountBalanceHistoryById id: ChainObject,
                       assets: [ChainObject] = [],
                       recipientAccount: ChainObject? = nil,
                       fromBlock: UInt64 = 0,
                       toBlock: UInt64 = 0,
                       startOffset: UInt64 = 0,
                       limit: Int = 100) -> Single<[BalanceChange]> {
     
        return SearchAccountBalanceHistory(accountId: id,
                                           assets: assets,
                                           recipientAccount: recipientAccount,
                                           fromBlock: fromBlock,
                                           toBlock: toBlock,
                                           startOffset: startOffset, limit: limit).toRequest(core: self.api.core)
    }
    
    public func getAccountBalanceForTransaction(byAccountId id: ChainObject, operationId: ChainObject) -> Single<BalanceChange> {
        return GetAccountBalanceForTransaction(accountId: id, operationId: operationId).toRequest(core: self.api.core)
    }
}
