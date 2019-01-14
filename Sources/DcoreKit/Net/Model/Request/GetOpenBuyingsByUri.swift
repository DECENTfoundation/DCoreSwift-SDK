import Foundation

struct GetOpenBuyingsByUri: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init(_ uri: String) {
        self.base = GetOpenBuyingsByUri.toBase(
            .database, api: "get_open_buyings_by_URI", returnClass: [Purchase].self, params: [uri]
        )
    }
}
