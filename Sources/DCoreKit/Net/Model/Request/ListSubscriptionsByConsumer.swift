import Foundation

struct ListSubscriptionsByConsumer: BaseRequestConvertible {
    
    typealias Output = [Subscription]
    private(set) var base: BaseRequest<[Subscription]>
    
    init(_ consumerId: ChainObject, count: Int) {
        precondition(consumerId.objectType == .accountObject, "Not a valid account object id")
        self.base = ListSubscriptionsByConsumer.toBase(
            .database,
            api: "list_subscriptions_by_consumer",
            returnType: [Subscription].self,
            params: [consumerId, count]
        )
    }
}
