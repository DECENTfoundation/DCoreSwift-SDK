import Foundation

struct GetBuyingByUri: BaseRequestConvertible {
    
    typealias Output = Purchase
    private(set) var base: BaseRequest<Purchase>
    
    init(_ consumerId: ChainObject, uri: String) {
        
        precondition(consumerId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetBuyingByUri.toBase(
            .database,
            api: "get_buying_by_consumer_uri",
            returnClass: Purchase.self,
            params: [consumerId, uri]
        )
    }
}
