import Foundation

class SearchFeedback: BaseRequest<[Purchase]> {
    
    required init(user: String?,
                  uri: String,
                  startId: ChainObject = ObjectType.NULL_OBJECT.genericId,
                  count: Int) {
        super.init(api: .DATABASE, method: "search_feedback", returnClass: [Purchase].self, params: [user ?? "", uri, startId, count])
    }
}
