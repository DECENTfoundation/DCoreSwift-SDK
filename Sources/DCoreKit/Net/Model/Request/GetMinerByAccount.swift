import Foundation

struct GetMinerByAccount: BaseRequestConvertible {
    
    typealias Output = Miner
    private(set) var base: BaseRequest<Miner>
    
    init(_ accountId: ChainObject) {
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        self.base = GetMinerByAccount.toBase(
            .database, api: "get_miner_by_account", returnType: Miner.self, params: [accountId]
        )
    }
}
