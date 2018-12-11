import Foundation

class GetBuyingByConsumer: BaseRequest<Purchase> {
    
    required init(consumer: ChainObject) {
        guard consumer.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid asset object id") }
        super.init(api: .DATABASE, method: "get_buying_by_consumer", returnClass: Purchase.self, params: [consumer])
    }
}
