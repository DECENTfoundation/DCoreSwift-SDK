import Foundation

struct GetAccountBalanceForTransaction<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = BalanceChange<Input>
    private(set) var base: BaseRequest<BalanceChange<Input>>
    
    init(_ accountId: ChainObject, operationId: ChainObject) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id \(accountId)")
        precondition(operationId.objectType == .operationHistoryObject, "Not a valid history object id \(operationId)")
        
        self.base = GetAccountBalanceForTransaction.toBase(
            .history, api: "get_account_balance_for_transaction", returnType: BalanceChange<Input>.self, params: [
                accountId, operationId
            ]
        )
    }
}
