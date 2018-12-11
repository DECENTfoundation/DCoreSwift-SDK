import Foundation

class GetAccountBalances: BaseRequest<[AssetAmount]> {
    
    required init(accountId: ChainObject, assets:[ChainObject] = []) {
        guard accountId.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid account object id") }
        super.init(api: .DATABASE, method: "get_account_balances", returnClass: [AssetAmount].self, params: [accountId.objectId, assets])
    }
}
