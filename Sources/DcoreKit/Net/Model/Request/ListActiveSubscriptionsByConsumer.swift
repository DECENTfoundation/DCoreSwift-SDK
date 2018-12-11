import Foundation

class ListActiveSubscriptionsByConsumer: BaseRequest<[Subscription]> {
 
    required init(accountId: ChainObject, count: Int) {
        super.init(api: .DATABASE, method: "list_active_subscriptions_by_consumer", returnClass: [Subscription].self, params: [accountId, count])
    }
}
