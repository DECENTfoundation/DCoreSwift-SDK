import Foundation

class ListSubscriptionsByConsumer: BaseRequest<[Subscription]> {

    required init(consumer: ChainObject, count: Int) {
        super.init(api: .DATABASE, method: "list_subscriptions_by_consumer", returnClass: [Subscription].self, params: [consumer, count])
    }
}
