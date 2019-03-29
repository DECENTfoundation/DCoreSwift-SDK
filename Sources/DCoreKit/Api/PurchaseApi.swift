import Foundation
import RxSwift

public protocol PurchaseApi: BaseApi {
    /**
     Get consumer purchase by content url.
     
     - Parameter id: Consumer object id of the account, eg. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter url: A url of the content,
     as `URL` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if no matching was found.
     
     - Returns: `Purchase`.
     */
    func get(byConsumerId id: ChainObjectConvertible, url: URLConvertible) -> Single<Purchase>
    
    /**
     Get a list of open purchases.
     
     - Returns: Array `[Purchase]` of open purchases.
     */
    func getAllOpen() -> Single<[Purchase]>
    
    /**
     Get a list of open purchases for content URL.
     
     - Parameter url: A url of the content,
     as `URL` or `String` format.
     
     - Returns: Array `[Purchase]` of open purchases.
     */
    func getAllOpen(byUrl url: URLConvertible) -> Single<[Purchase]>

    /**
     Get a list of open purchases for consumer id.
     
     - Parameter id: Consumer object id of the account, eg. 1.2.*,
     as `ChainObject` or `String` format.
     
     - Returns: Array `[Purchase]` of open purchases.
     */
    func getAllOpen(byAccountId id: ChainObjectConvertible) -> Single<[Purchase]>
    
    /**
     Get a list of historical purchases for consumer id.
     
     - Parameter id: Consumer object id of the account, eg. 1.2.*,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if no matching block was found.
     
     - Returns: Array `[Purchase]` of historical purchases.
     */
    func getAllHistorical(byAccountId id: ChainObjectConvertible) -> Single<[Purchase]>
    
    /**
     Search consumer open and historical purchases.
     
     - Parameter id: Consumer object id of the account, eg. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter expression: Search expression.
     - Parameter from: From object id of the history object to start from,
     as `ChainObject` or `String` format,
     default `ObjectType.nullObject.genericId`.
     - Parameter order: Sort purchases,
     default `SearchOrder.Purchases.purchasedDesc`.
     - Parameter limit: Limit number of entries, max/default `100`.
     
     - Returns: Array `[Purchase]` of purchases.
     */
    func findAll(byConsumerId id: ChainObjectConvertible,
                 expression: String,
                 from: ChainObjectConvertible,
                 order: SearchOrder.Purchases,
                 limit: Int) -> Single<[Purchase]>

    /**
     Search for feedback.
     
     - Parameter url: A url of the content,
     as `URL` or `String` format.
     - Parameter author: Feedback author account name,
     default `nil`.
     - Parameter startId: Id of feedback object to start searching from,
     as `ChainObject` or `String` format,
     default `ObjectType.nullObject.genericId`.
     - Parameter limit: Limit number of entries, max/default `100`.
     
     - Returns: Array `[Purchase]` of purchases.
     */
    func findAllFeedback(byUrl url: URLConvertible,
                         author: String?,
                         startId: ChainObjectConvertible,
                         limit: Int) -> Single<[Purchase]>
}

extension PurchaseApi {
    public func get(byConsumerId id: ChainObjectConvertible, url: URLConvertible) -> Single<Purchase> {
        return Single.deferred {
            return GetBuyingByUri(
                try id.asChainObject(), uri: try url.asURI { Content.hasValid(uri: $0) }
            ).base.toResponse(self.api.core)
        }
    }
    
    public func getAllOpen() -> Single<[Purchase]> {
        return GetOpenBuyings().base.toResponse(api.core)
    }
    
    public func getAllOpen(byUrl url: URLConvertible) -> Single<[Purchase]> {
        return Single.deferred {
            return GetOpenBuyingsByUri(try url.asURI { Content.hasValid(uri: $0) }).base.toResponse(self.api.core)
        }
    }
    
    public func getAllOpen(byAccountId id: ChainObjectConvertible) -> Single<[Purchase]> {
        return Single.deferred {
            return GetOpenBuyingsByConsumer(try id.asChainObject()).base.toResponse(self.api.core)
        }
    }
    
    public func getAllHistorical(byAccountId id: ChainObjectConvertible) -> Single<[Purchase]> {
        return Single.deferred {
            return GetHistoryBuyingsByConsumer(try id.asChainObject()).base.toResponse(self.api.core)
        }
    }
    
    public func findAll(byConsumerId id: ChainObjectConvertible,
                        expression: String = "",
                        from: ChainObjectConvertible = ObjectType.nullObject.genericId,
                        order: SearchOrder.Purchases = .purchasedDesc,
                        limit: Int = 100) -> Single<[Purchase]> {
        return Single.deferred {
            return SearchBuyings(try id.asChainObject(), order: order, startId: try from.asChainObject(), term: expression, limit: limit)
                .base
                .toResponse(self.api.core)
        }
        
    }
    
    public func findAllFeedback(byUrl url: URLConvertible,
                                author: String? = nil,
                                startId: ChainObjectConvertible = ObjectType.nullObject.genericId,
                                limit: Int = 100) -> Single<[Purchase]> {
        return Single.deferred {
            return SearchFeedback(author, uri: try url.asURI(), startId: try startId.asChainObject(), count: limit)
                .base
                .toResponse(self.api.core)
        }
    }
}

extension ApiProvider: PurchaseApi {}
