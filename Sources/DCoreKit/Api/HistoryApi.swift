import Foundation
import RxSwift

public protocol HistoryApi: BaseApi {
    func getAccountHistory<Input>(byAccountId id: ChainObject,
                                  startId: ChainObject,
                                  stopId: ChainObject,
                                  limit: Int) -> Single<[OperationHistory<Input>]> where Input: Operation
    func getAnyAccountHistory(byAccountId id: ChainObject,
                              startId: ChainObject,
                              stopId: ChainObject,
                              limit: Int) -> Single<[AnyOperationHistory]>
    func getAccountHistoryRelative<Input>(byAccountId id: ChainObject,
                                          start: Int,
                                          limit: Int) -> Single<[OperationHistory<Input>]> where Input: Operation
    func getAnyAccountHistoryRelative(byAccountId id: ChainObject,
                                      start: Int,
                                      limit: Int) -> Single<[AnyOperationHistory]>
    // swiftlint:disable:next function_parameter_count
    func search<Input>(accountBalanceHistoryById id: ChainObject,
                       assets: [ChainObject],
                       recipientAccount: ChainObject?,
                       fromBlock: UInt64,
                       toBlock: UInt64,
                       startOffset: UInt64,
                       limit: Int) -> Single<[BalanceChange<Input>]> where Input: Operation
    // swiftlint:disable:next function_parameter_count
    func searchAny(accountBalanceHistoryById id: ChainObject,
                   assets: [ChainObject],
                   recipientAccount: ChainObject?,
                   fromBlock: UInt64,
                   toBlock: UInt64,
                   startOffset: UInt64,
                   limit: Int) -> Single<[AnyBalanceChange]>
    func getAccountBalanceForTransaction<Input>(byAccountId id: ChainObject,
                                                operationId: ChainObject) -> Single<BalanceChange<Input>> where Input: Operation
    func getAnyAccountBalanceForTransaction(byAccountId id: ChainObject,
                                            operationId: ChainObject) -> Single<AnyBalanceChange>
}

extension HistoryApi {
    public func getAccountHistory<Input>(byAccountId id: ChainObject,
                                         startId: ChainObject = ObjectType.operationHistoryObject.genericId,
                                         stopId: ChainObject = ObjectType.operationHistoryObject.genericId,
                                         limit: Int = 100) -> Single<[OperationHistory<Input>]> where Input: Operation {
        
        return GetAccountHistory(id, stopId: stopId, limit: limit, startId: startId).base.toResponse(api.core)
    }
    
    public func getAnyAccountHistory(byAccountId id: ChainObject,
                                     startId: ChainObject = ObjectType.operationHistoryObject.genericId,
                                     stopId: ChainObject = ObjectType.operationHistoryObject.genericId,
                                     limit: Int = 100) -> Single<[AnyOperationHistory]> {
        return getAccountHistory(byAccountId: id, startId: startId, stopId: stopId, limit: limit)
    }
    
    public func getAccountHistoryRelative<Input>(byAccountId id: ChainObject,
                                                 start: Int = 0,
                                                 limit: Int = 100) -> Single<[OperationHistory<Input>]> where Input: Operation {
        
        return GetRelativeAccountHistory(id, stop: 0, limit: limit, start: start).base.toResponse(api.core)
    }
    
    public func getAnyAccountHistoryRelative(byAccountId id: ChainObject,
                                             start: Int = 0,
                                             limit: Int = 100) -> Single<[AnyOperationHistory]> {
        
        return getAccountHistoryRelative(byAccountId: id, start: start, limit: limit)
    }
    
    public func search<Input>(accountBalanceHistoryById id: ChainObject,
                              assets: [ChainObject] = [],
                              recipientAccount: ChainObject? = nil,
                              fromBlock: UInt64 = 0,
                              toBlock: UInt64 = 0,
                              startOffset: UInt64 = 0,
                              limit: Int = 100) -> Single<[BalanceChange<Input>]> where Input: Operation {
        
        return SearchAccountBalanceHistory(id,
                                           assets: assets,
                                           recipientAccount: recipientAccount,
                                           fromBlock: fromBlock,
                                           toBlock: toBlock,
                                           startOffset: startOffset, limit: limit).base.toResponse(api.core)
    }
    
    public func searchAny(accountBalanceHistoryById id: ChainObject,
                          assets: [ChainObject] = [],
                          recipientAccount: ChainObject? = nil,
                          fromBlock: UInt64 = 0,
                          toBlock: UInt64 = 0,
                          startOffset: UInt64 = 0,
                          limit: Int = 100) -> Single<[AnyBalanceChange]> {
        
        return search(accountBalanceHistoryById: id,
                      assets: assets,
                      recipientAccount: recipientAccount,
                      fromBlock: fromBlock,
                      toBlock: toBlock,
                      startOffset: startOffset,
                      limit: limit)
    }
    
    public func getAccountBalanceForTransaction<Input>(byAccountId id: ChainObject,
                                                       operationId: ChainObject) -> Single<BalanceChange<Input>> where Input: Operation {
        return GetAccountBalanceForTransaction(id, operationId: operationId).base.toResponse(api.core)
    }
    
    public func getAnyAccountBalanceForTransaction(byAccountId id: ChainObject,
                                                   operationId: ChainObject) -> Single<AnyBalanceChange> {
        return getAccountBalanceForTransaction(byAccountId: id, operationId: operationId)
    }
}

extension ApiProvider: HistoryApi {}
