import Foundation

class GetNamedAccountBalances: BaseRequest<[AssetAmount]> {
    
    required init(account: String, assets: [ChainObject] = []) {
        guard Account.isValid(with: account) else { preconditionFailure("invalid account") }
        guard assets.allSatisfy({ $0.objectType == ObjectType.ASSET_OBJECT }) else { preconditionFailure("not a valid asset object id") }
        super.init(api: .DATABASE, method: "get_named_account_balances", returnClass: [AssetAmount].self, params: [account, assets])
    }
}
