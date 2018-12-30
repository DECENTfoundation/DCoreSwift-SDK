import Foundation

class GetNamedAccountBalances: BaseRequest<[AssetAmount]> {
    
    required init(account: String, assets: [ChainObject] = []) {
        guard Account.hasValid(name: account) else { preconditionFailure("invalid account name") }
        guard assets.allSatisfy({ $0.objectType == ObjectType.assetObject }) else { preconditionFailure("not a valid asset object id") }
        super.init(.database, api: "get_named_account_balances", returnClass: [AssetAmount].self, params: [account, assets])
    }
}
