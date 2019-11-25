import Foundation

struct SearchAccountBalanceHistory: BaseRequestConvertible {
    
    typealias Output = [BalanceChange]
    private(set) var base: BaseRequest<[BalanceChange]>
    
    init(_ accountId: AccountObjectId,
         assets: [AssetObjectId] = [],
         recipientAccount: AccountObjectId? = nil,
         fromBlock: UInt64 = 0,
         toBlock: UInt64 = 0,
         startOffset: UInt64 = 0,
         limit: UInt64 = 100) {
        self.base = SearchAccountBalanceHistory.toBase(
            .history, api: "search_account_balance_history", returnType: [BalanceChange].self, params: [
                accountId, assets, recipientAccount, fromBlock, toBlock, startOffset, limit
            ]
        )
    }
}
