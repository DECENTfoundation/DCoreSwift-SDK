import Foundation

struct ListSubscriptionsByAuthor: BaseRequestConvertible {
    
    typealias Output = [Subscription]
    private(set) var base: BaseRequest<[Subscription]>
    
    init(_ authorId: AccountObjectId, count: Int) {
        self.base = ListSubscriptionsByAuthor.toBase(
            .database, api: "list_subscriptions_by_author", returnType: [Subscription].self, params: [
                authorId, count
            ]
        )
    }
}
