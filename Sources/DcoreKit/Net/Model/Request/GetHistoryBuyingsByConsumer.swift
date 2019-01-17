import Foundation

struct GetHistoryBuyingsByConsumer: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ consumerId: ChainObject) {
        
        precondition(consumerId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetHistoryBuyingsByConsumer.toBase(
            .database, api: "get_buying_history_objects_by_consumer", returnType: [Purchase].self, params: [consumerId]
        )
    }
}
