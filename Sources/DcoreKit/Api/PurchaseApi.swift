import Foundation
import RxSwift

public final class PurchaseApi: BaseApi {
    
    public func search(purchasesByConsumerId id: ChainObject,
                       term: String = "",
                       from: ChainObject = ObjectType.nullObject.genericId,
                       order: SearchOrder.Purchases = .purchasedDesc,
                       limit: Int = 100) -> Single<[Purchase]> {
        
        return SearchBuyings(id, order: order, startId: from, term: term, limit: limit).base.asCoreRequest(api.core)
    }

    public func getPurchase(byConsumerId id: ChainObject, uri: String) -> Single<Purchase> {
        return GetBuyingByUri(id, uri: uri).base.asCoreRequest(api.core)
    }

    public func getOpenPurchases() -> Single<[Purchase]> {
        return GetOpenBuyings().base.asCoreRequest(api.core)
    }
    
    public func getOpenPurchases(uri: String) -> Single<[Purchase]> {
        return GetOpenBuyingsByUri(uri).base.asCoreRequest(api.core)
    }
    
    public func getOpenPurchases(byAccountId id: ChainObject) -> Single<[Purchase]> {
        return GetOpenBuyingsByConsumer(id).base.asCoreRequest(api.core)
    }
    
    public func getHistoryPurchases(byAccountId id: ChainObject) -> Single<[Purchase]> {
        return GetHistoryBuyingsByConsumer(id).base.asCoreRequest(api.core)
    }
    
    public func search(feedbackByUri uri: String,
                       user: String? = nil,
                       count: Int = 100,
                       startId: ChainObject = ObjectType.nullObject.genericId) -> Single<[Purchase]> {
        
        return SearchFeedback(user, uri: uri, startId: startId, count: count).base.asCoreRequest(api.core)
    }
    
    public func getSubscription(byId id: ChainObject) -> Single<Subscription> {
        return GetSubscription(id).base.asCoreRequest(api.core)
    }
    
    public func listActiveSubscriptions(byConsumerId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListActiveSubscriptionsByConsumer(id, count: count).base.asCoreRequest(api.core)
    }
    
    public func listActiveSubscriptions(byAuthorId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListActiveSubscriptionsByAuthor(id, count: count).base.asCoreRequest(api.core)
    }
    
    public func listSubscriptions(byConsumerId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListSubscriptionsByConsumer(id, count: count).base.asCoreRequest(api.core)
    }
    
    public func listSubscriptions(byAuthorId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListSubscriptionsByAuthor(id, count: count).base.asCoreRequest(api.core)
    }
}
