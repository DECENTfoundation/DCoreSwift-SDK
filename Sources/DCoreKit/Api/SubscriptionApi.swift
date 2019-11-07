import Foundation
import RxSwift

public protocol SubscriptionApi: BaseApi {
    /**
     Get a subscription object by id.
     
     - Parameter id: Subscription object id, eg. 2.15.*,
     as `SubscriptionObjectId` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if subscription does not exist.
     
     - Returns: `Subscription` object.
     */
    func get(byId id: ObjectIdConvertible) -> Single<Subscription>
    
    /**
     Check if the account exist.
     
     - Parameter id: Consumer account object id, eg. 1.2.*,
     as `AccountObjectId` or `String` format.
     - Parameter limit: Maximum number of subscription objects to fetch,
     must not exceed 100.
     
     - Returns: `true` if account exist.
     */
    func getAllActive(byConsumerId id: ObjectIdConvertible, limit: Int) -> Single<[Subscription]>
    
    /**
     Check if the account exist.
     
     - Parameter id: Author account object id, eg. 1.2.*,
     as `AccountObjectId` or `String` format.
     - Parameter limit: Maximum number of subscription objects to fetch,
     must not exceed 100.
     
     - Returns: `true` if account exist.
     */
    func getAllActive(byAuthorId id: ObjectIdConvertible, limit: Int) -> Single<[Subscription]>
    
    /**
     Check if the account exist.
     
     - Parameter id: Consumer account object id, eg. 1.2.*,
     as `AccountObjectId` or `String` format.
     - Parameter limit: Maximum number of subscription objects to fetch,
     must not exceed 100.
     
     - Returns: `true` if account exist.
     */
    func getAll(byConsumerId id: ObjectIdConvertible, limit: Int) -> Single<[Subscription]>
    
    /**
     Check if the account exist.
     
     - Parameter id: Author account object id, eg. 1.2.*,
     as `AccountObjectId` or `String` format.
     - Parameter limit: Maximum number of subscription objects to fetch,
     must not exceed 100.
     
     - Returns: `true` if account exist.
     */
    func getAll(byAuthorId id: ObjectIdConvertible, limit: Int) -> Single<[Subscription]>
}

extension SubscriptionApi {
    public func get(byId id: ObjectIdConvertible) -> Single<Subscription> {
        return Single.deferred {
            return GetSubscription(try id.asObjectId()).base.toResponse(self.api.core)
        }
    }
    
    public func getAllActive(byConsumerId id: ObjectIdConvertible, limit: Int = DCore.Limits.subscriber) -> Single<[Subscription]> {
        return Single.deferred {
            return ListActiveSubscriptionsByConsumer(try id.asObjectId(), count: try limit.limited(by: DCore.Limits.subscriber))
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func getAllActive(byAuthorId id: ObjectIdConvertible, limit: Int = DCore.Limits.subscriber) -> Single<[Subscription]> {
        return Single.deferred {
            return ListActiveSubscriptionsByAuthor(try id.asObjectId(), count: try limit.limited(by: DCore.Limits.subscriber))
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func getAll(byConsumerId id: ObjectIdConvertible, limit: Int = DCore.Limits.subscriber) -> Single<[Subscription]> {
        return Single.deferred {
            return ListSubscriptionsByConsumer(try id.asObjectId(), count: try limit.limited(by: DCore.Limits.subscriber))
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func getAll(byAuthorId id: ObjectIdConvertible, limit: Int = DCore.Limits.subscriber) -> Single<[Subscription]> {
        return Single.deferred {
            return ListSubscriptionsByAuthor(try id.asObjectId(), count: try limit.limited(by: DCore.Limits.subscriber))
                .base
                .toResponse(self.api.core)
        }
    }
}

extension ApiProvider: SubscriptionApi {}
