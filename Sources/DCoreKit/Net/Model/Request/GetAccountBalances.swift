import Foundation

struct GetAccountBalances: BaseRequestConvertible {
    
    typealias Output = [AssetAmount]
    private(set) var base: BaseRequest<[AssetAmount]>
    
    init(_ accountId: ChainObject, assets: [ChainObject] = []) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        precondition(assets.allSatisfy { $0.objectType == .assetObject }, "Not a valid asset object id")
        
        self.base = GetAccountBalances.toBase(
            .database,
            api: "get_account_balances",
            returnType: [AssetAmount].self,
            params: [accountId, assets]
        )
    }
}
