import Foundation

class GetAccountBalanceForTransaction: BaseRequest<BalanceChange> {
    
    required init(accountId: ChainObject, operationId: ChainObject) {
        guard accountId.objectType == ObjectType.accountObject else { preconditionFailure("Not a valid account object id \(accountId)") }
        guard operationId.objectType == ObjectType.operationHistoryObject else { preconditionFailure("Not a valid history object id \(operationId)") }

        super.init(.history, api: "get_account_balance_for_transaction", returnClass: BalanceChange.self, params: [accountId, operationId])
    }
}
