import Foundation

class LookupAssets: BaseRequest<[Asset]> {
 
    required init(assets: [String]) {
        super.init(api: .DATABASE, method: "lookup_asset_symbols", returnClass: [Asset].self, params: [assets])
    }
}
