import Foundation

class SearchAccounts: BaseRequest<[Account]> {
    
    required init(searchTerm: String,
                  order: SearchOrder.Accounts = .nameDesc,
                  id: ChainObject = ObjectType.nullObject.genericId,
                  limit: Int = 1000) {
        super.init(.database, api: "search_accounts", returnClass: [Account].self, params: [searchTerm, order.rawValue, id, limit])
    }
}
