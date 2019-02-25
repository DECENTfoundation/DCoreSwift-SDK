import Foundation

struct ListAssets: BaseRequestConvertible {
    
    typealias Output = [Asset]
    private(set) var base: BaseRequest<[Asset]>
    
    init(_ bound: String, limit: Int = DCore.Constant.assetLimit) {
        precondition(limit <= DCore.Constant.assetLimit, "Asset limit is out of bound: \(DCore.Constant.assetLimit)")
        self.base = ListAssets.toBase(.database, api: "list_assets", returnType: [Asset].self, params: [bound, limit])
    }
}
