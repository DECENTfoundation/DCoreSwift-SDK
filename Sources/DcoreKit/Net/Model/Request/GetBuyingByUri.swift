import Foundation

class GetBuyingByUri: BaseRequest<Purchase> {
    
    required init(consumer: ChainObject, uri: String) {
        guard consumer.objectType == ObjectType.accountObject else { preconditionFailure("not a valid asset object id") }
        super.init(.database, api: "get_buying_by_consumer_uri", returnClass: Purchase.self, params: [consumer, uri])
    }
}
