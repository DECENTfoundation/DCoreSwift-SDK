import Foundation

class GetAccountBalances: BaseRequest<[AssetAmount]> {
    
    required init(accountId: ChainObject, assets:[ChainObject] = []) {
        precondition(accountId.objectType == ObjectType.accountObject,"not a valid account object id")
        super.init(.database, api: "get_account_balances", returnClass: [AssetAmount].self, params: [accountId.objectId, assets])
    }
}
