import Foundation

class SearchContent: BaseRequest<[Content]> {
    
    required init(term: String,
                  order: SearchContentOrder = .CREATED_DESC,
                  user: String,
                  regionCode: String,
                  type: String,
                  startId: ChainObject = ObjectType.NULL_OBJECT.genericId,
                  limit: Int = 100) {
        super.init(api: .DATABASE, method: "search_content", returnClass: [Content].self, params: [
            term, order.rawValue, user, regionCode, type, startId, limit
        ])
    }
}
