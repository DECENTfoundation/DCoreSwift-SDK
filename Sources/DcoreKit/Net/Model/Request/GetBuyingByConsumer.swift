import Foundation

class GetBuyingByConsumer: BaseRequest<Purchase> {
    
    required init(consumer: ChainObject) {
        
        precondition(consumer.objectType == .accountObject, "Not a valid asset object id")
        super.init(.database, api: "get_buying_by_consumer", returnClass: Purchase.self, params: [consumer])
    }
}
