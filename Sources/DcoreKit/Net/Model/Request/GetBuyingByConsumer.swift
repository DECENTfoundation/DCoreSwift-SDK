import Foundation

struct GetBuyingByConsumer: BaseRequestConvertible {
    
    typealias Output = Purchase
    private(set) var base: BaseRequest<Purchase>
    
    init(_ consumerId: ChainObject) {
        
        precondition(consumerId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetBuyingByConsumer.toBase(
            .database, api: "get_buying_by_consumer", returnType: Purchase.self, params: [consumerId]
        )
    }
}
