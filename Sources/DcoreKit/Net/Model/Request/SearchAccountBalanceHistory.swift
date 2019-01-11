import Foundation

struct SearchAccountBalanceHistory: BaseRequestConvertible {
    
    typealias Output = [BalanceChange]
    private(set) var base: BaseRequest<[BalanceChange]>
    
    init(_ accountId: ChainObject,
         assets: [ChainObject] = [],
         recipientAccount: ChainObject? = nil,
         fromBlock: UInt64 = 0,
         toBlock: UInt64 = 0,
         startOffset: UInt64 = 0,
         limit: Int = 100) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        self.base = SearchAccountBalanceHistory.toBase(.history, api: "search_account_balance_history", returnClass: [BalanceChange].self, params: [
            accountId, assets, recipientAccount ?? "", fromBlock, toBlock, startOffset, limit
            ])
    }
}
