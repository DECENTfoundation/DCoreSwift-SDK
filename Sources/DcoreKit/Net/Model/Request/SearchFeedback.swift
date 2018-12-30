import Foundation

class SearchFeedback: BaseRequest<[Purchase]> {
    
    required init(user: String?,
                  uri: String,
                  startId: ChainObject = ObjectType.nullObject.genericId,
                  count: Int) {
        super.init(.database, api: "search_feedback", returnClass: [Purchase].self, params: [user ?? "", uri, startId, count])
    }
}
