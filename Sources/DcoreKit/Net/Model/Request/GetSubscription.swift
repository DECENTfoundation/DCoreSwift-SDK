import Foundation

class GetSubscription: BaseRequest<Subscription> {
    
    required init(subscriptionId: ChainObject) {
        super.init(api: .DATABASE, method: "get_subscription", returnClass: Subscription.self, params: [subscriptionId])
    }
}
