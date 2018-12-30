import Foundation

class GetAssets: BaseRequest<[Asset]> {
    
    required init(ids: [ChainObject]) {
        guard ids.allSatisfy({ $0.objectType ==  ObjectType.assetObject }) else { preconditionFailure("not a valid asset object id") }
        super.init(.database, api: "get_assets", returnClass: [Asset].self, params: [ids])
    }
}
