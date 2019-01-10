import Foundation

class GetAccountBalanceForTransaction: BaseRequest<BalanceChange> {
    
    required init(accountId: ChainObject, operationId: ChainObject) {
        precondition(accountId.objectType == ObjectType.accountObject, "Not a valid account object id \(accountId)")
        precondition(operationId.objectType == ObjectType.operationHistoryObject,"Not a valid history object id \(operationId)") 

        super.init(.history, api: "get_account_balance_for_transaction", returnClass: BalanceChange.self, params: [accountId, operationId])
    }
}
