import Foundation

class ListActiveSubscriptionsByConsumer: BaseRequest<[Subscription]> {
 
    required init(_ consumerId: ChainObject, count: Int) {
        super.init(.database, api: "list_active_subscriptions_by_consumer", returnClass: [Subscription].self, params: [consumerId, count])
    }
}
