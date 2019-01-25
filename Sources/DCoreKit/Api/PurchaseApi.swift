import Foundation
import RxSwift

public protocol PurchaseApi: BaseApi {
    func search(purchasesByConsumerId id: ChainObject,
                term: String,
                from: ChainObject,
                order: SearchOrder.Purchases,
                limit: Int) -> Single<[Purchase]>
    func getPurchase(byConsumerId id: ChainObject, uri: String) -> Single<Purchase>
    func getOpenPurchases() -> Single<[Purchase]>
    func getOpenPurchases(byUri uri: String) -> Single<[Purchase]>
    func getOpenPurchases(byAccountId id: ChainObject) -> Single<[Purchase]>
    func getHistoryPurchases(byAccountId id: ChainObject) -> Single<[Purchase]>
    func search(feedbackByUri uri: String,
                user: String?,
                count: Int,
                startId: ChainObject) -> Single<[Purchase]>
    func getSubscription(byId id: ChainObject) -> Single<Subscription>
    func listActiveSubscriptions(byConsumerId id: ChainObject, count: Int) -> Single<[Subscription]>
    func listActiveSubscriptions(byAuthorId id: ChainObject, count: Int) -> Single<[Subscription]>
    func listSubscriptions(byConsumerId id: ChainObject, count: Int) -> Single<[Subscription]>
    func listSubscriptions(byAuthorId id: ChainObject, count: Int) -> Single<[Subscription]>
}

extension PurchaseApi {
    public func search(purchasesByConsumerId id: ChainObject,
                       term: String = "",
                       from: ChainObject = ObjectType.nullObject.genericId,
                       order: SearchOrder.Purchases = .purchasedDesc,
                       limit: Int = 100) -> Single<[Purchase]> {
        
        return SearchBuyings(id, order: order, startId: from, term: term, limit: limit).base.toResponse(api.core)
    }
    
    public func getPurchase(byConsumerId id: ChainObject, uri: String) -> Single<Purchase> {
        return GetBuyingByUri(id, uri: uri).base.toResponse(api.core)
    }
    
    public func getOpenPurchases() -> Single<[Purchase]> {
        return GetOpenBuyings().base.toResponse(api.core)
    }
    
    public func getOpenPurchases(byUri uri: String) -> Single<[Purchase]> {
        return GetOpenBuyingsByUri(uri).base.toResponse(api.core)
    }
    
    public func getOpenPurchases(byAccountId id: ChainObject) -> Single<[Purchase]> {
        return GetOpenBuyingsByConsumer(id).base.toResponse(api.core)
    }
    
    public func getHistoryPurchases(byAccountId id: ChainObject) -> Single<[Purchase]> {
        return GetHistoryBuyingsByConsumer(id).base.toResponse(api.core)
    }
    
    public func search(feedbackByUri uri: String,
                       user: String? = nil,
                       count: Int = 100,
                       startId: ChainObject = ObjectType.nullObject.genericId) -> Single<[Purchase]> {
        
        return SearchFeedback(user, uri: uri, startId: startId, count: count).base.toResponse(api.core)
    }
    
    public func getSubscription(byId id: ChainObject) -> Single<Subscription> {
        return GetSubscription(id).base.toResponse(api.core)
    }
    
    public func listActiveSubscriptions(byConsumerId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListActiveSubscriptionsByConsumer(id, count: count).base.toResponse(api.core)
    }
    
    public func listActiveSubscriptions(byAuthorId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListActiveSubscriptionsByAuthor(id, count: count).base.toResponse(api.core)
    }
    
    public func listSubscriptions(byConsumerId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListSubscriptionsByConsumer(id, count: count).base.toResponse(api.core)
    }
    
    public func listSubscriptions(byAuthorId id: ChainObject, count: Int) -> Single<[Subscription]> {
        return ListSubscriptionsByAuthor(id, count: count).base.toResponse(api.core)
    }
}

extension ApiProvider: PurchaseApi {}