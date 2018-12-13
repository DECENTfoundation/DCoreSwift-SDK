import Foundation

class GetAssets: BaseRequest<[Asset]> {
    
    required init(ids: [ChainObject]) {
        guard ids.allSatisfy({ $0.objectType ==  ObjectType.ASSET_OBJECT }) else { preconditionFailure("not a valid asset object id") }
        super.init(api: .DATABASE, method: "get_assets", returnClass: [Asset].self, params: [ids])
    }
}
