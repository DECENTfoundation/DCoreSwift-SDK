import Foundation
import RxSwift

extension Pagination {
    public static let unsetHistoryObject: Pagination = .pageObject(bounds: ObjectType.unsetHistory..<(ObjectType.unsetHistory), limit: 100)
}

public protocol HistoryApi: BaseApi {
    func get(byAccountId id: ChainObjectConvertible,
             operationId: ChainObjectConvertible) -> Single<BalanceChange>
    func getAll(byAccountId id: ChainObjectConvertible,
                pagination: Pagination) -> Single<[OperationHistory]>
    func getAllRelative(byAccountId id: ChainObjectConvertible,
                        pagination: Pagination) -> Single<[OperationHistory]>
    func findAll(byAccountId id: ChainObjectConvertible,
                 assets: [ChainObjectConvertible],
                 recipientId: ChainObjectConvertible?,
                 pagination: Pagination) -> Single<[BalanceChange]>
}

extension HistoryApi {
    public func get(byAccountId id: ChainObjectConvertible,
                    operationId: ChainObjectConvertible) -> Single<BalanceChange> {
        return Single.deferred {
            return GetAccountBalanceForTransaction(
                try id.asChainObject(), operationId: try operationId.asChainObject()
            ).base.toResponse(self.api.core)
        }
    }
    
    public func getAll(byAccountId id: ChainObjectConvertible,
                       pagination: Pagination = .unsetHistoryObject) -> Single<[OperationHistory]> {
        return Single.deferred {
            guard case .pageObject(let bounds, let limit) = pagination else {
                return Single.error(DCoreException.unexpected("Unsupported pagination use pageObject."))
            }
            return GetAccountHistory(try id.asChainObject(), stopId: bounds.upperBound, limit: limit, startId: bounds.lowerBound)
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func getAllRelative(byAccountId id: ChainObjectConvertible,
                               pagination: Pagination = .ignore) -> Single<[OperationHistory]> {
        return Single.deferred {
            guard case .page(let bounds, _, let limit) = pagination else {
                return Single.error(DCoreException.unexpected("Unsupported pagination use page."))
            }
            return GetRelativeAccountHistory(try id.asChainObject(), stop: 0, limit: limit, start: bounds.lowerBound)
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func findAll(byAccountId id: ChainObjectConvertible,
                        assets: [ChainObjectConvertible] = [],
                        recipientId: ChainObjectConvertible? = nil,
                        pagination: Pagination = .ignore) -> Single<[BalanceChange]> {
        return Single.deferred {
            guard case .page(let bounds, let offset, let limit) = pagination else {
                return Single.error(DCoreException.unexpected("Unsupported pagination use page."))
            }
            return SearchAccountBalanceHistory(try id.asChainObject(),
                                               assets: try assets.map { try $0.asChainObject() },
                                               recipientAccount: try recipientId?.asChainObject(),
                                               fromBlock: bounds.lowerBound,
                                               toBlock: bounds.upperBound,
                                               startOffset: offset, limit: limit).base.toResponse(self.api.core)
        }
    }
}

extension ApiProvider: HistoryApi {}
