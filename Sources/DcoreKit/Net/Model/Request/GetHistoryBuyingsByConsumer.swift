import Foundation

class GetHistoryBuyingsByConsumer: BaseRequest<[Purchase]> {
    
    required init(consumer: ChainObject) {
        
        precondition(consumer.objectType == .accountObject, "Not a valid asset object id")
        super.init(.database, api: "get_buying_history_objects_by_consumer", returnClass: [Purchase].self, params: [consumer])
    }
}
