import Foundation
import RxSwift

extension Pagination {
    public static let unsetHistoryObject: Pagination = .pageObject(bounds: ObjectType.unsetHistory..<(ObjectType.unsetHistory), limit: 100)
}

public protocol HistoryApi: BaseApi {
    /**
     Get balance operation change by account id and operation id.
     
     - Parameter id: Account id,
     as `AccountObjectId` or `String` format.
     - Parameter operationId: Operation id,
     as `OperationHistoryObjectId` or `String` format.
     
     - Returns: `BalanceChange`.
     */
    func get(byAccountId id: AccountObjectIdConvertible,
             operationId: ObjectIdConvertible) -> Single<BalanceChange>
    
    /**
     Get account history of operations.
     
     - Parameter id: Account id,
     as `AccountObjectId` or `String` format.
     - Parameter pagination: `Pagination` object.
     
     - Returns: Array `[OperationHistory]` of operations,
     performed by account, ordered from most recent to oldest.
     */
    func getAll(byAccountId id: AccountObjectIdConvertible,
                pagination: Pagination) -> Single<[OperationHistory]>
    
    /**
     Get account history of operations.
     
     - Parameter id: Account id,
     as `AccountObjectId` or `String` format.
     - Parameter pagination: `Pagination` object.
     
     - Returns: Array `[OperationHistory]` of operations,
     performed by account, ordered from most recent to oldest.
     */
    func getAllRelative(byAccountId id: AccountObjectIdConvertible,
                        pagination: Pagination) -> Single<[OperationHistory]>
    
    /**
     Returns the most recent balance operations on the named account.
     This returns a list of operation history objects,
     which describe activity on the account.
     
     - Parameter id: Account id,
     as `AccountObjectId` or `String` format.
     - Parameter assets: Assets ids,
     default `[]` for all assets.
     - Parameter recipientId: Partner account object id,
     to filter transfers to specific account,
     default `nil`, as `AccountObjectId` or `String` format.
     - Parameter pagination: `Pagination` object.
     
     - Returns: Array `[BalanceChange]` of balance changes.
     */
    func findAll(byAccountId id: AccountObjectIdConvertible,
                 assets: [AssetObjectIdConvertible],
                 recipientId: AccountObjectIdConvertible?,
                 pagination: Pagination) -> Single<[BalanceChange]>
}

extension HistoryApi {
    public func get(byAccountId id: AccountObjectIdConvertible,
                    operationId: ObjectIdConvertible) -> Single<BalanceChange> {
        return Single.deferred {
            return GetAccountBalanceForTransaction(
                try id.asAccountObjectId(), operationId: try operationId.asObjectId()
            ).base.toResponse(self.api.core)
        }
    }
    
    public func getAll(byAccountId id: AccountObjectIdConvertible,
                       pagination: Pagination = .unsetHistoryObject) -> Single<[OperationHistory]> {
        return Single.deferred {
            guard case .pageObject(let bounds, let limit) = pagination,
                let upperBound = bounds.upperBound as? OperationHistoryObjectId,
                let lowerBound = bounds.lowerBound as? OperationHistoryObjectId
            else { return Single.error(DCoreException.unexpected("Unsupported pagination use pageObject.")) }
            return GetAccountHistory(try id.asAccountObjectId(), stopId: upperBound, limit: limit, startId: lowerBound)
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func getAllRelative(byAccountId id: AccountObjectIdConvertible,
                               pagination: Pagination = .ignore) -> Single<[OperationHistory]> {
        return Single.deferred {
            guard case .page(let bounds, _, let limit) = pagination else {
                return Single.error(DCoreException.unexpected("Unsupported pagination use page."))
            }
            return GetRelativeAccountHistory(
                try id.asAccountObjectId(), stop: 0, limit: limit, start: bounds.lowerBound)
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func findAll(byAccountId id: AccountObjectIdConvertible,
                        assets: [AssetObjectIdConvertible] = [],
                        recipientId: AccountObjectIdConvertible? = nil,
                        pagination: Pagination = .ignore) -> Single<[BalanceChange]> {
        return Single.deferred {
            guard case .page(let bounds, let offset, let limit) = pagination else {
                return Single.error(DCoreException.unexpected("Unsupported pagination use page."))
            }
            return SearchAccountBalanceHistory(try id.asAccountObjectId(),
                                               assets: try assets.map { try $0.asAssetObjectId() },
                                               recipientAccount: try recipientId?.asAccountObjectId(),
                                               fromBlock: bounds.lowerBound,
                                               toBlock: bounds.upperBound,
                                               startOffset: offset, limit: limit).base.toResponse(self.api.core)
        }
    }
}

extension ApiProvider: HistoryApi {}
