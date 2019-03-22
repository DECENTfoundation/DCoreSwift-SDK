import Foundation

struct GetFullAccounts: BaseRequestConvertible {
    
    typealias Output = [String: FullAccount]
    private(set) var base: BaseRequest<[String: FullAccount]>
    
    init(_ namesOrIds: [String], subscribe: Bool) {
        precondition(namesOrIds.allSatisfy {
            Account.hasValid(name: $0) || ((try? $0.asChainObject().objectType) == .accountObject)
        }, "Not a valid account object id or name")
        
        self.base = GetFullAccounts.toBase(
            .database,
            api: "get_full_accounts",
            returnType: [String: FullAccount].self,
            params: [namesOrIds, subscribe]
        )
    }
}
