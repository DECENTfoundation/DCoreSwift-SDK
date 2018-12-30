import Foundation

class ListPublishingManagers: BaseRequest<[ChainObject]> {
    
    required init(lowerBound: String, limit: Int = 100) {
        super.init(.database, api: "list_publishing_managers", returnClass: [ChainObject].self, params: [lowerBound, limit])
    }
}
