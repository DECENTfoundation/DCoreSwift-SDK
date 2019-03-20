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
}

extension ApiProvider: PurchaseApi {}
