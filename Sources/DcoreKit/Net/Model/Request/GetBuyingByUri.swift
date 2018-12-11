import Foundation

class GetBuyingByUri: BaseRequest<Purchase> {
    
    required init(consumer: ChainObject, uri: String) {
        guard consumer.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid asset object id") }
        super.init(api: .DATABASE, method: "get_buying_by_consumer_URI", returnClass: Purchase.self, params: [consumer, uri])
    }
}
