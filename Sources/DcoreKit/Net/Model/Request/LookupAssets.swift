import Foundation

class LookupAssets: BaseRequest<[Asset]> {
 
    required init(symbols: [Asset.Symbol]) {
        super.init(.database, api: "lookup_asset_symbols", returnClass: [Asset].self, params: [symbols])
    }
}
