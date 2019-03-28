import Foundation

struct GetSubscription: BaseRequestConvertible {
    
    typealias Output = Subscription
    private(set) var base: BaseRequest<Subscription>
    
    init(_ subscriptionId: ChainObject) {
        precondition(subscriptionId.objectType == .subscriptionObject, "Not a valid subscription object id")
        self.base = GetSubscription.toBase(
            .database,
            api: "get_subscription",
            returnType: Subscription.self,
            params: [subscriptionId]
        )
    }
}
