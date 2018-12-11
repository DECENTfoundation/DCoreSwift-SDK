import Foundation

class GetAssets: BaseRequest<[Asset]> {
    
    required init(assets: [ChainObject]) {
        guard assets.allSatisfy({ $0.objectType ==  ObjectType.ASSET_OBJECT }) else { preconditionFailure("not a valid asset object id") }
        super.init(api: .DATABASE, method: "get_assets", returnClass: [Asset].self, params: [assets])
    }
}
