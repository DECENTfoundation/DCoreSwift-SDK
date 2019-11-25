import Foundation

struct LookupAccounts: BaseRequestConvertible {
    
    typealias Output = [String: AccountObjectId]
    private(set) var base: BaseRequest<[String: AccountObjectId]>
    
    init(_ bound: String, limit: Int = 1000) {
        self.base = LookupAccounts.toBase(
            .database, api: "lookup_accounts", returnType: [String: AccountObjectId].self, params: [
                bound, limit
            ]
        )
    }
}
