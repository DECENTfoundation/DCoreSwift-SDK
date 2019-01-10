import Foundation

class GetAssets: BaseRequest<[Asset]> {
    
    required init(ids: [ChainObject]) {
        
        precondition(ids.allSatisfy{ $0.objectType == .assetObject }, "Not a valid asset object id")
        super.init(.database, api: "get_assets", returnClass: [Asset].self, params: [ids])
    }
}
