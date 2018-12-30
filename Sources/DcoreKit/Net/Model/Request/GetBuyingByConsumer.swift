import Foundation

class GetBuyingByConsumer: BaseRequest<Purchase> {
    
    required init(consumer: ChainObject) {
        guard consumer.objectType == ObjectType.accountObject else { preconditionFailure("not a valid asset object id") }
        super.init(.database, api: "get_buying_by_consumer", returnClass: Purchase.self, params: [consumer])
    }
}
