import Foundation

struct SearchFeedback: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ user: String?,
         uri: String,
         startId: ChainObject = ObjectType.nullObject.genericId,
         count: Int) {
        
        self.base = SearchFeedback.toBase(.database, api: "search_feedback", returnClass: [Purchase].self, params: [user ?? "", uri, startId, count])
    }
}
