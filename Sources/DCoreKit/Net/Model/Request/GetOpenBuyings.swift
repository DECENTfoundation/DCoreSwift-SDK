import Foundation

struct GetOpenBuyings: BaseRequestConvertible {
    
    typealias Output = [Purchase]
    private(set) var base: BaseRequest<[Purchase]>
    
    init() {
        self.base = GetOpenBuyings.toBase(.database, api: "get_open_buyings", returnType: [Purchase].self)
    }
}
