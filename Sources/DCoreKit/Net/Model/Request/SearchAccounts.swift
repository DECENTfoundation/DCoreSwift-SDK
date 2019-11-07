import Foundation

struct SearchAccounts: BaseRequestConvertible {
    
    typealias Output = [Account]
    private(set) var base: BaseRequest<[Account]>
    
    init(_ term: String,
         order: SearchOrder.Accounts = .nameDesc,
         id: AccountObjectId? = nil,
         limit: Int = 1000) {
        self.base = SearchAccounts.toBase(
            .database,
            api: "search_accounts",
            returnType: [Account].self,
            params: [term, order, id.or(ObjectType.accountObject.genericId()), limit]
        )
    }
}
