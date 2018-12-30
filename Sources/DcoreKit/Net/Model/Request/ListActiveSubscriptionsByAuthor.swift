import Foundation

class ListActiveSubscriptionsByAuthor: BaseRequest<[Subscription]> {
 
    required init(_ authorid: ChainObject, count: Int) {
        super.init(.database, api: "list_active_subscriptions_by_author", returnClass: [Subscription].self, params: [authorid, count])
    }
}
