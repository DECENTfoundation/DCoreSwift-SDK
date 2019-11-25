import Foundation

struct ListSubscriptionsByConsumer: BaseRequestConvertible {
    
    typealias Output = [Subscription]
    private(set) var base: BaseRequest<[Subscription]>
    
    init(_ consumerId: AccountObjectId, count: Int) {
        self.base = ListSubscriptionsByConsumer.toBase(
            .database,
            api: "list_subscriptions_by_consumer",
            returnType: [Subscription].self,
            params: [consumerId, count]
        )
    }
}
