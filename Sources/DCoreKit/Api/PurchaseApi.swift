import Foundation
import RxSwift

public protocol PurchaseApi: BaseApi {
    /**
     Get consumer purchase by content url.
     
     - Parameter id: Consumer object id of the account, eg. 1.2.*,
     as `AccountObjectId` or `String` format.
     - Parameter url: A url of the content,
     as `URL` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if no matching was found.
     
     - Returns: `Purchase`.
     */
    func get(byConsumerId id: ObjectIdConvertible, url: URLConvertible) -> Single<Purchase>
    
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
     as `AccountObjectId` or `String` format.
     
     - Returns: Array `[Purchase]` of open purchases.
     */
    func getAllOpen(byAccountId id: ObjectIdConvertible) -> Single<[Purchase]>
    
    /**
     Get a list of historical purchases for consumer id.
     
     - Parameter id: Consumer object id of the account, eg. 1.2.*,
     as `AccountObjectId` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if no matching block was found.
     
     - Returns: Array `[Purchase]` of historical purchases.
     */
    func getAllHistorical(byAccountId id: ObjectIdConvertible) -> Single<[Purchase]>
    
    /**
     Search consumer open and historical purchases.
     
     - Parameter id: Consumer object id of the account, eg. 1.2.*,
     as `AccountObjectId` or `String` format.
     - Parameter expression: Search expression.
     - Parameter from: From object id of the history object to start from,
     as `PurchaseObjectId` or `String` format,
     default `ObjectId.nullObjectId`.
     - Parameter order: Sort purchases,
     default `SearchOrder.Purchases.purchasedDesc`.
     - Parameter limit: Limit number of entries, max/default `100`.
     
     - Returns: Array `[Purchase]` of purchases.
     */
    func findAll(byConsumerId id: ObjectIdConvertible,
                 expression: String,
                 from: ObjectIdConvertible,
                 order: SearchOrder.Purchases,
                 limit: Int) -> Single<[Purchase]>

    /**
     Search for feedback.
     
     - Parameter url: A url of the content,
     as `URL` or `String` format.
     - Parameter author: Feedback author account name,
     default `nil`.
     - Parameter startId: Id of feedback object to start searching from,
     as `PurchaseObjectId` or `String` format,
     default `ObjectId.nullObjectId()`.
     - Parameter limit: Limit number of entries, max/default `100`.
     
     - Returns: Array `[Purchase]` of purchases.
     */
    func findAllFeedback(byUrl url: URLConvertible,
                         author: String?,
                         startId: ObjectIdConvertible,
                         limit: Int) -> Single<[Purchase]>
}

extension PurchaseApi {
    public func get(byConsumerId id: ObjectIdConvertible, url: URLConvertible) -> Single<Purchase> {
        return Single.deferred {
            return GetBuyingByUri(
                try id.asObjectId(), uri: try url.asURI { Content.hasValid(uri: $0) }
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
    
    public func getAllOpen(byAccountId id: ObjectIdConvertible) -> Single<[Purchase]> {
        return Single.deferred {
            return GetOpenBuyingsByConsumer(try id.asObjectId()).base.toResponse(self.api.core)
        }
    }
    
    public func getAllHistorical(byAccountId id: ObjectIdConvertible) -> Single<[Purchase]> {
        return Single.deferred {
            return GetHistoryBuyingsByConsumer(try id.asObjectId()).base.toResponse(self.api.core)
        }
    }
    
    public func findAll(byConsumerId id: ObjectIdConvertible,
                        expression: String = "",
                        from: ObjectIdConvertible = ObjectId.nullObjectId,
                        order: SearchOrder.Purchases = .purchasedDesc,
                        limit: Int = 100) -> Single<[Purchase]> {
        return Single.deferred {
            return SearchBuyings(try id.asObjectId(), order: order, startId: try from.asObjectId(), term: expression, limit: limit)
                .base
                .toResponse(self.api.core)
        }
        
    }
    
    public func findAllFeedback(byUrl url: URLConvertible,
                                author: String? = nil,
                                startId: ObjectIdConvertible = ObjectId.nullObjectId,
                                limit: Int = 100) -> Single<[Purchase]> {
        return Single.deferred {
            return SearchFeedback(author, uri: try url.asURI(), startId: try startId.asObjectId(), count: limit)
                .base
                .toResponse(self.api.core)
        }
    }
}

extension ApiProvider: PurchaseApi {}
