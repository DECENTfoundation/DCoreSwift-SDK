import Foundation

struct SearchContent: BaseRequestConvertible {
    
    typealias Output = [Content]
    private(set) var base: BaseRequest<[Content]>
    
    init(_ term: String,
         order: SearchOrder.Content = .createdDesc,
         user: String,
         regionCode: String,
         type: String,
         startId: ChainObject = ObjectType.nullObject.genericId,
         limit: Int = 100) {
     
        precondition(Account.hasValid(name: user), "Not valid account object name")
        precondition(startId.objectType == .nullObject || startId.objectType == .contentObject, "Not a valid null or content object id")
        
        self.base = SearchContent.toBase(.database, api: "search_content", returnType: [Content].self, params: [
            term, order, user, regionCode, type, startId, limit
            ])
    }
}
