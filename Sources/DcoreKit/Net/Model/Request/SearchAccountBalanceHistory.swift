import Foundation

class SearchAccountBalanceHistory: BaseRequest<[BalanceChange]> {
    
    required init(accountId: ChainObject,
                  assets: [ChainObject] = [],
                  recipientAccount: ChainObject? = nil,
                  fromBlock: UInt64 = 0,
                  toBlock: UInt64 = 0,
                  startOffset: UInt64 = 0,
                  limit: Int = 100) {
        super.init(.history, api: "search_account_balance_history", returnClass: [BalanceChange].self, params: [
            accountId, assets, recipientAccount ?? "", fromBlock, toBlock, startOffset, limit
        ])
    }
}
