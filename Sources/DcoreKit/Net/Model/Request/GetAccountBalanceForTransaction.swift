import Foundation

class GetAccountBalanceForTransaction: BaseRequest<BalanceChange> {
    
    required init(accountId: ChainObject, operationId: ChainObject) {
        guard accountId.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid account object id") }
        guard operationId.objectType == ObjectType.OPERATION_HISTORY_OBJECT else { preconditionFailure("not a valid history object id") }

        super.init(api: .HISTORY, method: "get_account_balance_for_transaction", returnClass: BalanceChange.self, params: [accountId, operationId])
    }
}
