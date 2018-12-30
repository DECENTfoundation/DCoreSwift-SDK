import Foundation

class ListSubscriptionsByConsumer: BaseRequest<[Subscription]> {

    required init(_ consumerId: ChainObject, count: Int) {
        super.init(.database, api: "list_subscriptions_by_consumer", returnClass: [Subscription].self, params: [consumerId, count])
    }
}
