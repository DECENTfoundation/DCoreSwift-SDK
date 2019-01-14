import Foundation

struct ListAssets: BaseRequestConvertible {
    
    typealias Output = [Asset]
    private(set) var base: BaseRequest<[Asset]>
    
    init(_ bound: String, limit: Int = 100) {
        self.base = ListAssets.toBase(.database, api: "list_assets", returnClass: [Asset].self, params: [bound, limit])
    }
}
