import Foundation

class SearchContent: BaseRequest<[Content]> {
    
    required init(term: String,
                  order: SearchOrder.Content = .createdDesc,
                  user: String,
                  regionCode: String,
                  type: String,
                  startId: ChainObject = ObjectType.nullObject.genericId,
                  limit: Int = 100) {
        super.init(.database, api: "search_content", returnClass: [Content].self, params: [
            term, order.rawValue, user, regionCode, type, startId, limit
        ])
    }
}
