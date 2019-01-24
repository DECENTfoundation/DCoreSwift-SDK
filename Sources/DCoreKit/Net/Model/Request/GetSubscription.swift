import Foundation

struct GetSubscription: BaseRequestConvertible {
    
    typealias Output = Subscription
    private(set) var base: BaseRequest<Subscription>
    
    init(_ subscriptionId: ChainObject) {
        self.base = GetSubscription.toBase(
            .database,
            api: "get_subscription",
            returnType: Subscription.self,
            params: [subscriptionId]
        )
    }
}
