import Foundation

class SearchBuyings: BaseRequest<[Purchase]> {
    
    required init(consumer: ChainObject,
                  order: SearchPurchasesOrder = .PURCHASED_DESC,
                  startId: ChainObject = ObjectType.NULL_OBJECT.genericId,
                  term: String = "",
                  limit: Int = 100) {
        
        guard consumer.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid account object id") }
        guard startId == ObjectType.NULL_OBJECT.genericId || startId.objectType == ObjectType.BUYING_OBJECT else {
            preconditionFailure("not a valid null or buying object id")
        }
        super.init(api: .DATABASE, method: "get_buying_objects_by_consumer", returnClass: [Purchase].self, params: [
            consumer.objectId, order.rawValue, startId.objectId, term, max(0, min(100, limit))
        ])
    }
}
