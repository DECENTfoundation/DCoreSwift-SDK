import Foundation

struct SearchAccountBalanceHistory<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = [BalanceChange<Input>]
    private(set) var base: BaseRequest<[BalanceChange<Input>]>
    
    init(_ accountId: ChainObject,
         assets: [ChainObject] = [],
         recipientAccount: ChainObject? = nil,
         fromBlock: UInt64 = 0,
         toBlock: UInt64 = 0,
         startOffset: UInt64 = 0,
         limit: Int = 100) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        self.base = SearchAccountBalanceHistory.toBase(
            .history, api: "search_account_balance_history", returnType: [BalanceChange<Input>].self, params: [
                accountId, assets, recipientAccount ?? "", fromBlock, toBlock, startOffset, limit
            ]
        )
    }
}
