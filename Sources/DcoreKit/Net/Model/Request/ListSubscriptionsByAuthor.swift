import Foundation

struct ListSubscriptionsByAuthor: BaseRequestConvertible {
    
    typealias Output = [Subscription]
    private(set) var base: BaseRequest<[Subscription]>
    
    init(_ authorId: ChainObject, count: Int) {
        self.base = ListSubscriptionsByAuthor.toBase(.database, api: "list_subscriptions_by_author", returnClass: [Subscription].self, params: [authorId, count])
    }
}
