import Foundation
import RxSwift

public final class PurchaseApi: BaseApi {
    
    public func search(purchasesByConsumerId id: ChainObject,
                       term: String = "",
                       from: ChainObject = ObjectType.nullObject.genericId,
                       order: SearchPurchasesOrder = .PURCHASED_DESC,
                       limit: Int = 100) -> Single<[Purchase]> {
        
        return SearchBuyings(consumer: id, order: order, startId: from, term: term, limit: limit).asCoreRequest(api.core)
    }

    public func getPurchase(byConsumerId id: ChainObject, uri: String) -> Single<Purchase> {
        return GetBuyingByUri(consumer: id, uri: uri).asCoreRequest(api.core)
    }

    public func getOpenPurchases() -> Single<[Purchase]> {
        return GetOpenBuyings().asCoreRequest(api.core)
    }
    
    public func getOpenPurchases(uri: String) -> Single<[Purchase]> {
        return GetOpenBuyingsByUri(uri: uri).asCoreRequest(api.core)
    }
    
    public func getOpenPurchases(byAccountId id: ChainObject) -> Single<[Purchase]> {
        return GetOpenBuyingsByConsumer(consumer: id).asCoreRequest(api.core)
    }
    
    public func getHistoryPurchases(byAccountId id: ChainObject) -> Single<[Purchase]> {
        return GetHistoryBuyingsByConsumer(consumer: id).asCoreRequest(api.core)
    }
    
    public func search(feedbackByUri uri: String,
                       user: String? = nil,
                       count: Int = 100,
                       startId: ChainObject = ObjectType.nullObject.genericId) -> Single<[Purchase]> {
        
        return SearchFeedback(user: user, uri: uri, startId: startId, count: count).asCoreRequest(api.core)
    }
    
    public func getSubscription(byId id: ChainObject) -> Single<Subscription> {
        return GetSubscription(subscriptionId: id).asCoreRequest(api.core)
    }
    
    public func listActiveSubscriptions(byConsumerId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListActiveSubscriptionsByConsumer(id, count: count).asCoreRequest(api.core)
    }
    
    public func listActiveSubscriptions(byAuthorId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListActiveSubscriptionsByAuthor(id, count: count).asCoreRequest(api.core)
    }
    
    public func listSubscriptions(byConsumerId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListSubscriptionsByConsumer(id, count: count).asCoreRequest(api.core)
    }
    
    public func listSubscriptions(byAuthorId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListSubscriptionsByAuthor(id, count: count).asCoreRequest(api.core)
    }
}
