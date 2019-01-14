import Foundation

struct SearchBuyings: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ consumerId: ChainObject,
         order: SearchOrder.Purchases = .purchasedDesc,
         startId: ChainObject = ObjectType.nullObject.genericId,
         term: String = "",
         limit: Int = 100) {
        
        precondition(consumerId.objectType == .accountObject, "Not a valid account object id")
        precondition(startId == ObjectType.nullObject.genericId || startId.objectType == .buyingObject,
                     "Not a valid null or buying object id"
        )
        self.base = SearchBuyings.toBase(
            .database,
            api: "get_buying_objects_by_consumer",
            returnClass: [Purchase].self,
            params: [
                consumerId, order, startId, term, max(0, min(100, limit))
            ]
        )
    }
}
