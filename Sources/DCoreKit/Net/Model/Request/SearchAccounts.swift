import Foundation

struct SearchAccounts: BaseRequestConvertible {
    
    typealias Output = [Account]
    private(set) var base: BaseRequest<[Account]>
    
    init(_ term: String,
         order: SearchOrder.Accounts = .nameDesc,
         id: ChainObject = ObjectType.nullObject.genericId,
         limit: Int = 1000) {
        
        precondition(id.objectType == .nullObject || id.objectType == .accountObject, "Not valid account object id")
        
        self.base = SearchAccounts.toBase(
            .database,
            api: "search_accounts",
            returnType: [Account].self,
            params: [term, order, id, limit]
        )
    }
}
