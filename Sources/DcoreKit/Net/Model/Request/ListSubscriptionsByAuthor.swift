import Foundation

class ListSubscriptionsByAuthor: BaseRequest<[Subscription]> {
    
    required init(_ authorId: ChainObject, count: Int) {
        super.init(.database, api: "list_subscriptions_by_author", returnClass: [Subscription].self, params: [authorId, count])
    }
}
