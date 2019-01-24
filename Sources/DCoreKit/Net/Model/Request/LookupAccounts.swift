import Foundation

struct LookupAccounts: BaseRequestConvertible {
    
    typealias Output = [String: ChainObject]
    private(set) var base: BaseRequest<[String: ChainObject]>
    
    init(_ bound: String, limit: Int = 1000) {
        self.base = LookupAccounts.toBase(
            .database, api: "lookup_accounts", returnType: [String: ChainObject].self, params: [
                bound, limit
            ]
        )
    }
}
