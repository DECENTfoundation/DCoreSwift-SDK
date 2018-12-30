import Foundation

class GetSubscription: BaseRequest<Subscription> {
    
    required init(subscriptionId: ChainObject) {
        super.init(.database, api: "get_subscription", returnClass: Subscription.self, params: [subscriptionId])
    }
}
