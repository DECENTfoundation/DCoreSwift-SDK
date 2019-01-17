import Foundation

struct GetFullAccounts: BaseRequestConvertible {
    
    typealias Output = [String: FullAccount]
    private(set) var base: BaseRequest<[String: FullAccount]>
    
    init(_ namesOrIds: [String], subscribe: Bool) {
        self.base = GetFullAccounts.toBase(
            .database,
            api: "get_full_accounts",
            returnType: [String: FullAccount].self,
            params: [namesOrIds, subscribe]
        )
    }
}
