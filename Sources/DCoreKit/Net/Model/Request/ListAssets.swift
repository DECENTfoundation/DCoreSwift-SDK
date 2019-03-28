import Foundation

struct ListAssets: BaseRequestConvertible {
    
    typealias Output = [Asset]
    private(set) var base: BaseRequest<[Asset]>
    
    init(_ bound: String, limit: Int = DCore.Limits.asset) {
        precondition(limit <= DCore.Limits.asset, "Asset limit is out of bound: \(DCore.Limits.asset)")
        self.base = ListAssets.toBase(.database, api: "list_assets", returnType: [Asset].self, params: [bound, limit])
    }
}
