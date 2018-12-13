import Foundation

class ListSubscriptionsByAuthor: BaseRequest<[Subscription]> {
    
    required init(author: ChainObject, count: Int) {
        super.init(api: .DATABASE, method: "list_subscriptions_by_author", returnClass: [Subscription].self, params: [author, count])
    }
}
