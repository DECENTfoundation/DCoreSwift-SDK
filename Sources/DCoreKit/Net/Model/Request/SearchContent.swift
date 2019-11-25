import Foundation

struct SearchContent: BaseRequestConvertible {
    
    typealias Output = [Content]
    private(set) var base: BaseRequest<[Content]>
    
    init(_ term: String,
         order: SearchOrder.Content = .createdDesc,
         user: String,
         regionCode: String,
         type: String,
         startId: ContentObjectId? = nil,
         limit: Int = 100) {
     
        precondition(Account.hasValid(name: user), "Not valid account object name")
        
        self.base = SearchContent.toBase(.database, api: "search_content", returnType: [Content].self, params: [
            term, order, user, regionCode, type, startId ?? ObjectId.nullObjectId, limit
            ])
    }
}
