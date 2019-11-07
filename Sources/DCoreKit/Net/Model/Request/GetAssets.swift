import Foundation

struct GetAssets: BaseRequestConvertible {
    
    typealias Output = [Asset]
    private(set) var base: BaseRequest<[Asset]>
    
    init(_ ids: [AssetObjectId]) {
        self.base = GetAssets.toBase(.database, api: "get_assets", returnType: [Asset].self, params: [ids])
    }
}
