import Foundation

struct GetBuyingByUri: BaseRequestConvertible {
    
    typealias Output = Purchase
    private(set) var base: BaseRequest<Purchase>
    
    init(_ consumerId: AccountObjectId, uri: String) {
        self.base = GetBuyingByUri.toBase(
            .database,
            api: "get_buying_by_consumer_uri",
            returnType: Purchase.self,
            params: [consumerId, uri]
        )
    }
}
