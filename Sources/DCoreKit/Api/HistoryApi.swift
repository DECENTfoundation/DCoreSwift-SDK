import Foundation
import RxSwift

extension Pagination {
    public static let ignoreHistoryObject: Pagination = .pageObject(bounds: ObjectType.ignoreHistory..<(ObjectType.ignoreHistory), limit: 100)
}

public protocol HistoryApi: BaseApi {
    func getHistory<Input>(for accountId: ChainObject,
                           pagination: Pagination) -> Single<[OperationHistory<Input>]> where Input: Operation
    func getAnyHistory(for accountId: ChainObject,
                       pagination: Pagination) -> Single<[AnyOperationHistory]>
    
    func getRelativeHistory<Input>(for accountId: ChainObject,
                                   pagination: Pagination) -> Single<[OperationHistory<Input>]> where Input: Operation
    func getAnyRelativeHistory(for accountId: ChainObject,
                               pagination: Pagination) -> Single<[AnyOperationHistory]>
    func getBalanceHistory<Input>(for accountId: ChainObject,
                                  assets: [ChainObject],
                                  recipientId: ChainObject?,
                                  pagination: Pagination) -> Single<[BalanceChange<Input>]> where Input: Operation
    func getAnyBalanceHistory(for accountId: ChainObject,
                              assets: [ChainObject],
                              recipientId: ChainObject?,
                              pagination: Pagination) -> Single<[AnyBalanceChange]>
    func getTransactionBalanceHistory<Input>(for accountId: ChainObject,
                                             operationId: ChainObject) -> Single<BalanceChange<Input>> where Input: Operation
    func getAnyTransactionBalanceHistory(for accountId: ChainObject,
                                         operationId: ChainObject) -> Single<AnyBalanceChange>
}

extension HistoryApi {
    public func getHistory<Input>(for accountId: ChainObject,
                                  pagination: Pagination = .ignoreHistoryObject) -> Single<[OperationHistory<Input>]> where Input: Operation {
        guard case .pageObject(let bounds, let limit) = pagination else {
            return Single.error(DCoreException.unexpected("Unsupported pagination use pageObject."))
        }
        return GetAccountHistory(accountId, stopId: bounds.upperBound, limit: limit, startId: bounds.lowerBound).base.toResponse(api.core)
    }
    
    public func getAnyHistory(for accountId: ChainObject,
                              pagination: Pagination = .ignoreHistoryObject) -> Single<[AnyOperationHistory]> {
        return getHistory(for: accountId, pagination: pagination)
    }
    
    public func getRelativeHistory<Input>(for accountId: ChainObject,
                                          pagination: Pagination = .ignore) -> Single<[OperationHistory<Input>]> where Input: Operation {
        guard case .page(let bounds, _, let limit) = pagination else {
            return Single.error(DCoreException.unexpected("Unsupported pagination use page."))
        }
        return GetRelativeAccountHistory(accountId, stop: 0, limit: limit, start: bounds.lowerBound).base.toResponse(api.core)
    }
    
    public func getAnyRelativeHistory(for accountId: ChainObject,
                                      pagination: Pagination = .ignore) -> Single<[AnyOperationHistory]> {
        
        return getRelativeHistory(for: accountId, pagination: pagination)
    }
    
    public func getBalanceHistory<Input>(for accountId: ChainObject,
                                         assets: [ChainObject] = [],
                                         recipientId: ChainObject? = nil,
                                         pagination: Pagination = .ignore) -> Single<[BalanceChange<Input>]> where Input: Operation {
        guard case .page(let bounds, let offset, let limit) = pagination else {
            return Single.error(DCoreException.unexpected("Unsupported pagination use page."))
        }
        return SearchAccountBalanceHistory(accountId,
                                           assets: assets,
                                           recipientAccount: recipientId,
                                           fromBlock: bounds.lowerBound,
                                           toBlock: bounds.upperBound,
                                           startOffset: offset, limit: limit).base.toResponse(api.core)
    }
    
    public func getAnyBalanceHistory(for accountId: ChainObject,
                                     assets: [ChainObject] = [],
                                     recipientId: ChainObject? = nil,
                                     pagination: Pagination = .ignore) -> Single<[AnyBalanceChange]> {
        
        return getBalanceHistory(for: accountId,
                                 assets: assets,
                                 recipientId: recipientId,
                                 pagination: pagination)
    }
    
    public func getTransactionBalanceHistory<Input>(for accountId: ChainObject,
                                                    operationId: ChainObject) -> Single<BalanceChange<Input>> where Input: Operation {
        return GetAccountBalanceForTransaction(accountId, operationId: operationId).base.toResponse(api.core)
    }
    
    public func getAnyTransactionBalanceHistory(for accountId: ChainObject,
                                                operationId: ChainObject) -> Single<AnyBalanceChange> {
        return getTransactionBalanceHistory(for: accountId, operationId: operationId)
    }
}

extension ApiProvider: HistoryApi {}
