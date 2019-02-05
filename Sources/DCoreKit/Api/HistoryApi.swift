import Foundation
import RxSwift

extension Pagination {
    public static let unsetHistoryObject: Pagination = .pageObject(bounds: ObjectType.unsetHistory..<(ObjectType.unsetHistory), limit: 100)
}

public protocol HistoryApi: BaseApi {
    func getHistory(for accountId: ChainObject,
                    pagination: Pagination) -> Single<[OperationHistory]>
    func getRelativeHistory(for accountId: ChainObject,
                            pagination: Pagination) -> Single<[OperationHistory]>
    func getBalanceHistory(for accountId: ChainObject,
                           assets: [ChainObject],
                           recipientId: ChainObject?,
                           pagination: Pagination) -> Single<[BalanceChange]>
    func getTransactionBalanceHistory(for accountId: ChainObject,
                                      operationId: ChainObject) -> Single<BalanceChange>
}

extension HistoryApi {
    public func getHistory(for accountId: ChainObject,
                           pagination: Pagination = .unsetHistoryObject) -> Single<[OperationHistory]> {
        guard case .pageObject(let bounds, let limit) = pagination else {
            return Single.error(DCoreException.unexpected("Unsupported pagination use pageObject."))
        }
        return GetAccountHistory(accountId, stopId: bounds.upperBound, limit: limit, startId: bounds.lowerBound).base.toResponse(api.core)
    }
    
    public func getRelativeHistory(for accountId: ChainObject,
                                   pagination: Pagination = .ignore) -> Single<[OperationHistory]> {
        guard case .page(let bounds, _, let limit) = pagination else {
            return Single.error(DCoreException.unexpected("Unsupported pagination use page."))
        }
        return GetRelativeAccountHistory(accountId, stop: 0, limit: limit, start: bounds.lowerBound).base.toResponse(api.core)
    }
    
    public func getBalanceHistory(for accountId: ChainObject,
                                  assets: [ChainObject] = [],
                                  recipientId: ChainObject? = nil,
                                  pagination: Pagination = .ignore) -> Single<[BalanceChange]> {
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
    
    public func getTransactionBalanceHistory(for accountId: ChainObject,
                                             operationId: ChainObject) -> Single<BalanceChange> {
        return GetAccountBalanceForTransaction(accountId, operationId: operationId).base.toResponse(api.core)
    }
}

extension ApiProvider: HistoryApi {}
