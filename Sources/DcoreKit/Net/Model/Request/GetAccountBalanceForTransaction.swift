import Foundation

class GetAccountBalanceForTransaction: BaseRequest<BalanceChange> {
    
    required init(accountId: ChainObject, operationId: ChainObject) {
        guard accountId.objectType == ObjectType.accountObject else { preconditionFailure("not a valid account object id") }
        guard operationId.objectType == ObjectType.operationHistoryObject else { preconditionFailure("not a valid history object id") }

        super.init(.history, api: "get_account_balance_for_transaction", returnClass: BalanceChange.self, params: [accountId, operationId])
    }
}
