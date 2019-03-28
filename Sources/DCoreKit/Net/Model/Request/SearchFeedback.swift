import Foundation

struct SearchFeedback: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ user: String?,
         uri: String,
         startId: ChainObject = ObjectType.nullObject.genericId,
         count: Int) {
        
        precondition(user.isNil() || Account.hasValid(name: user!), "Not valid account object name")
        precondition(startId.objectType == .nullObject || startId.objectType == .purchaseObject, "Not a valid null or purchase object id")
        
        self.base = SearchFeedback.toBase(
            .database,
            api: "search_feedback",
            returnType: [Purchase].self,
            params: [user, uri, startId, count]
        )
    }
}
