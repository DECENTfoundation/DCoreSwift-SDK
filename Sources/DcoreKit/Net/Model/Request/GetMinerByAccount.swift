import Foundation

struct GetMinerByAccount: BaseRequestConvertible {
    
    typealias Output = Miner
    private(set) var base: BaseRequest<Miner>
    
    init(_ accountId: ChainObject) {
        self.base = GetMinerByAccount.toBase(
            .database, api: "get_miner_by_account", returnClass: Miner.self, params: [accountId]
        )
    }
}
