import Foundation

class SearchBuyings: BaseRequest<[Purchase]> {
    
    required init(consumer: ChainObject,
                  order: SearchOrder.Purchases = .purchasedDesc,
                  startId: ChainObject = ObjectType.nullObject.genericId,
                  term: String = "",
                  limit: Int = 100) {
        
        precondition(consumer.objectType == ObjectType.accountObject, "Not a valid account object id")
        precondition(startId == ObjectType.nullObject.genericId || startId.objectType == ObjectType.buyingObject,
            "Not a valid null or buying object id"
        )
        
        super.init(.database, api: "get_buying_objects_by_consumer", returnClass: [Purchase].self, params: [
            consumer.objectId, order.rawValue, startId.objectId, term, max(0, min(100, limit))
        ])
    }
}
