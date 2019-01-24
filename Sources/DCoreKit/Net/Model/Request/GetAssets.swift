import Foundation

struct GetAssets: BaseRequestConvertible {
    
    typealias Output = [Asset]
    private(set) var base: BaseRequest<[Asset]>
    
    init(_ ids: [ChainObject]) {
        
        precondition(ids.allSatisfy { $0.objectType == .assetObject }, "Not a valid asset object id")
        self.base = GetAssets.toBase(.database, api: "get_assets", returnType: [Asset].self, params: [ids])
    }
}
