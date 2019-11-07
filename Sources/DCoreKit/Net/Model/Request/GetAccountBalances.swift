import Foundation

struct GetAccountBalances: BaseRequestConvertible {
    
    typealias Output = [AssetAmount]
    private(set) var base: BaseRequest<[AssetAmount]>
    
    init(_ accountId: AccountObjectId, assets: [AssetObjectId] = []) {        
        self.base = GetAccountBalances.toBase(
            .database,
            api: "get_account_balances",
            returnType: [AssetAmount].self,
            params: [accountId, assets]
        )
    }
}
