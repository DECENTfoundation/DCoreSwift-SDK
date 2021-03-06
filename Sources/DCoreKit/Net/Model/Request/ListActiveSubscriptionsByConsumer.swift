import Foundation

struct ListActiveSubscriptionsByConsumer: BaseRequestConvertible {
    
    typealias Output = [Subscription]
    private(set) var base: BaseRequest<[Subscription]>
    
    init(_ consumerId: AccountObjectId, count: Int) {
        self.base = ListActiveSubscriptionsByConsumer.toBase(
            .database,
            api: "list_active_subscriptions_by_consumer",
            returnType: [Subscription].self,
            params: [consumerId, count]
        )
    }
}
