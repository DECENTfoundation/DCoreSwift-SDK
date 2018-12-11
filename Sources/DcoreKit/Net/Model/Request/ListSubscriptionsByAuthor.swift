import Foundation

class ListSubscriptionsByAuthor: BaseRequest<[Subscription]> {
    
    required init(accountId: ChainObject, count: Int) {
        super.init(api: .DATABASE, method: "list_subscriptions_by_author", returnClass: [Subscription].self, params: [accountId, count])
    }
}
