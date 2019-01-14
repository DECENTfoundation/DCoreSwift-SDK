import Foundation

struct ListActiveSubscriptionsByAuthor: BaseRequestConvertible {
    
    typealias Output = [Subscription]
    private(set) var base: BaseRequest<[Subscription]>
    
    init(_ authorId: ChainObject, count: Int) {
        self.base = ListActiveSubscriptionsByAuthor.toBase(
            .database, api: "list_active_subscriptions_by_author", returnClass: [Subscription].self, params: [
                authorId, count
            ]
        )
    }
}
