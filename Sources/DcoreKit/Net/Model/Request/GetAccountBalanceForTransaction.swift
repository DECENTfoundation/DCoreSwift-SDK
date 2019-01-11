import Foundation

struct GetAccountBalanceForTransaction: BaseRequestConvertible {
    
    typealias Output = BalanceChange
    private(set) var base: BaseRequest<BalanceChange>
    
    init(_ accountId: ChainObject, operationId: ChainObject) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id \(accountId)")
        precondition(operationId.objectType == .operationHistoryObject, "Not a valid history object id \(operationId)")
        
        self.base = GetAccountBalanceForTransaction.toBase(
            .history, api: "get_account_balance_for_transaction", returnClass: BalanceChange.self, params: [accountId, operationId]
        )
    }
}
