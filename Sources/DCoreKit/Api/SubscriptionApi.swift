import Foundation
import RxSwift

public protocol SubscriptionApi: BaseApi {
    /**
     Get a subscription object by id.
     
     - Parameter id: Subscription object id, e.g. 2.15.*,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if subscription does not exist.
     
     - Returns: `Subscription` object.
     */
    func get(byId id: ChainObjectConvertible) -> Single<Subscription>
    
    /**
     Check if the account exist.
     
     - Parameter id: Consumer account object id, e.g. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter limit: Maximum number of subscription objects to fetch,
     must not exceed 100.
     
     - Returns: `true` if account exist.
     */
    func getAllActive(byConsumerId id: ChainObjectConvertible, limit: Int) -> Single<[Subscription]>
    
    /**
     Check if the account exist.
     
     - Parameter id: Author account object id, e.g. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter limit: Maximum number of subscription objects to fetch,
     must not exceed 100.
     
     - Returns: `true` if account exist.
     */
    func getAllActive(byAuthorId id: ChainObjectConvertible, limit: Int) -> Single<[Subscription]>
    
    /**
     Check if the account exist.
     
     - Parameter id: Consumer account object id, e.g. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter limit: Maximum number of subscription objects to fetch,
     must not exceed 100.
     
     - Returns: `true` if account exist.
     */
    func getAll(byConsumerId id: ChainObjectConvertible, limit: Int) -> Single<[Subscription]>
    
    /**
     Check if the account exist.
     
     - Parameter id: Author account object id, e.g. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter limit: Maximum number of subscription objects to fetch,
     must not exceed 100.
     
     - Returns: `true` if account exist.
     */
    func getAll(byAuthorId id: ChainObjectConvertible, limit: Int) -> Single<[Subscription]>
}

extension SubscriptionApi {
    public func get(byId id: ChainObjectConvertible) -> Single<Subscription> {
        return Single.deferred {
            return GetSubscription(try id.asChainObject()).base.toResponse(self.api.core)
        }
    }
    
    public func getAllActive(byConsumerId id: ChainObjectConvertible, limit: Int = DCore.Limits.subscriber) -> Single<[Subscription]> {
        return Single.deferred {
            return ListActiveSubscriptionsByConsumer(try id.asChainObject(), count: try limit.limited(by: DCore.Limits.subscriber))
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func getAllActive(byAuthorId id: ChainObjectConvertible, limit: Int = DCore.Limits.subscriber) -> Single<[Subscription]> {
        return Single.deferred {
            return ListActiveSubscriptionsByAuthor(try id.asChainObject(), count: try limit.limited(by: DCore.Limits.subscriber))
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func getAll(byConsumerId id: ChainObjectConvertible, limit: Int = DCore.Limits.subscriber) -> Single<[Subscription]> {
        return Single.deferred {
            return ListSubscriptionsByConsumer(try id.asChainObject(), count: try limit.limited(by: DCore.Limits.subscriber))
                .base
                .toResponse(self.api.core)
        }
    }
    
    public func getAll(byAuthorId id: ChainObjectConvertible, limit: Int = DCore.Limits.subscriber) -> Single<[Subscription]> {
        return Single.deferred {
            return ListSubscriptionsByAuthor(try id.asChainObject(), count: try limit.limited(by: DCore.Limits.subscriber))
                .base
                .toResponse(self.api.core)
        }
    }
}

extension ApiProvider: SubscriptionApi {}
