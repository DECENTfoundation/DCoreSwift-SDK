import Foundation

struct GetNamedAccountBalances: BaseRequestConvertible {
    
    typealias Output = [AssetAmount]
    private(set) var base: BaseRequest<[AssetAmount]>
    
    init(_ name: String, assets: [AssetObjectId] = []) {
        
        precondition(Account.hasValid(name: name), "Invalid account name")
        
        self.base = GetNamedAccountBalances.toBase(
            .database, api: "get_named_account_balances", returnType: [AssetAmount].self, params: [name, assets]
        )
    }
}
