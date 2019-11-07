import Foundation

struct GetAccountBalanceForTransaction: BaseRequestConvertible {
    
    typealias Output = BalanceChange
    private(set) var base: BaseRequest<BalanceChange>
    
    init(_ accountId: AccountObjectId, operationId: OperationHistoryObjectId) {        
        self.base = GetAccountBalanceForTransaction.toBase(
            .history, api: "get_account_balance_for_transaction", returnType: BalanceChange.self, params: [
                accountId, operationId
            ]
        )
    }
}
