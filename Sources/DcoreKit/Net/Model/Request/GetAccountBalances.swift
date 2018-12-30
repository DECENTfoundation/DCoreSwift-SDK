import Foundation

class GetAccountBalances: BaseRequest<[AssetAmount]> {
    
    required init(accountId: ChainObject, assets:[ChainObject] = []) {
        guard accountId.objectType == ObjectType.accountObject else { preconditionFailure("not a valid account object id") }
        super.init(.database, api: "get_account_balances", returnClass: [AssetAmount].self, params: [accountId.objectId, assets])
    }
}
