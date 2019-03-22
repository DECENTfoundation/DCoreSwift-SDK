import Foundation

struct ListActiveSubscriptionsByConsumer: BaseRequestConvertible {
    
    typealias Output = [Subscription]
    private(set) var base: BaseRequest<[Subscription]>
    
    init(_ consumerId: ChainObject, count: Int) {
        precondition(consumerId.objectType == .accountObject, "Not a valid account object id")
        self.base = ListActiveSubscriptionsByConsumer.toBase(
            .database,
            api: "list_active_subscriptions_by_consumer",
            returnType: [Subscription].self,
            params: [consumerId, count]
        )
    }
}
