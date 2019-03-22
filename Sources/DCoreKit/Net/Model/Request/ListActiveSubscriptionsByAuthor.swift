import Foundation

struct ListActiveSubscriptionsByAuthor: BaseRequestConvertible {
    
    typealias Output = [Subscription]
    private(set) var base: BaseRequest<[Subscription]>
    
    init(_ authorId: ChainObject, count: Int) {
        precondition(authorId.objectType == .accountObject, "Not a valid account object id")
        self.base = ListActiveSubscriptionsByAuthor.toBase(
            .database, api: "list_active_subscriptions_by_author", returnType: [Subscription].self, params: [
                authorId, count
            ]
        )
    }
}
