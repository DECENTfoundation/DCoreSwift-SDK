import Foundation

struct SearchBuyings: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ consumerId: AccountObjectId,
         order: SearchOrder.Purchases = .purchasedDesc,
         startId: PurchaseObjectId? = nil,
         term: String = "",
         limit: Int = 100) {
        self.base = SearchBuyings.toBase(
            .database,
            api: "get_buying_objects_by_consumer",
            returnType: [Purchase].self,
            params: [
                consumerId, order, startId ?? ObjectId.nullObjectId, term, max(0, min(100, limit))
            ]
        )
    }
}
