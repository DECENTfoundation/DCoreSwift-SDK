import Foundation

struct GetOpenBuyingsByConsumer: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ consumerId: ChainObject) {
        precondition(consumerId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetOpenBuyingsByConsumer.toBase(.database, api: "get_open_buyings_by_consumer", returnClass: [Purchase].self, params: [consumerId])
    }
}
