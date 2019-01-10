import Foundation

class GetNamedAccountBalances: BaseRequest<[AssetAmount]> {
    
    required init(account: String, assets: [ChainObject] = []) {
        
        precondition(Account.hasValid(name: account), "Invalid account name")
        precondition(assets.allSatisfy{ $0.objectType == .assetObject },"Not a valid asset object id")
            
        super.init(.database, api: "get_named_account_balances", returnClass: [AssetAmount].self, params: [account, assets])
    }
}
