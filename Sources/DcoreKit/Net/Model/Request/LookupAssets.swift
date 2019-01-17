import Foundation

struct LookupAssets: BaseRequestConvertible {
    
    typealias Output = [Asset]
    private(set) var base: BaseRequest<[Asset]>
    
    init(_ symbols: [Asset.Symbol]) {
        self.base = LookupAssets.toBase(
            .database, api: "lookup_asset_symbols", returnType: [Asset].self, params: [symbols]
        )
    }
}
