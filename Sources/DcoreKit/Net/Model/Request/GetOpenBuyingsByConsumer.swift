import Foundation

class GetOpenBuyingsByConsumer: BaseRequest<[Purchase]> {
    
    required init(consumer: ChainObject) {
        
        precondition(consumer.objectType == .accountObject, "Not a valid asset object id")
        super.init(.database, api: "get_open_buyings_by_consumer", returnClass: [Purchase].self, params: [consumer])
    }
}
