import Foundation

struct SearchFeedback: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ user: String?,
         uri: String,
         startId: PurchaseObjectId? = nil,
         count: Int) {
        
        precondition(user.isNil() || Account.hasValid(name: user!), "Not valid account object name")
        
        self.base = SearchFeedback.toBase(
            .database,
            api: "search_feedback",
            returnType: [Purchase].self,
            params: [user, uri, startId ?? ObjectId.nullObjectId, count]
        )
    }
}
