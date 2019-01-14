import Foundation

struct LookupMinerAccounts: BaseRequestConvertible {
    
    typealias Output = [MinerId]
    private(set) var base: BaseRequest<[MinerId]>
    
    init(_ term: String = "", limit: Int = 1000) {
        self.base = LookupMinerAccounts.toBase(
            .database, api: "lookup_miner_accounts", returnClass: [MinerId].self, params: [term, limit]
        )
    }
}
