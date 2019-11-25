import Foundation

struct GetOpenBuyingsByConsumer: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ consumerId: AccountObjectId) {
        self.base = GetOpenBuyingsByConsumer.toBase(
            .database,
            api: "get_open_buyings_by_consumer",
            returnType: [Purchase].self,
            params: [consumerId]
        )
    }
}
