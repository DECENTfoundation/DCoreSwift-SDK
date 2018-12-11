import Foundation

class ListSubscriptionsByConsumer: BaseRequest<[Subscription]> {

    required init(accountId: ChainObject, count: Int) {
        super.init(api: .DATABASE, method: "list_subscriptions_by_consumer", returnClass: [Subscription].self, params: [accountId, count])
    }
}
