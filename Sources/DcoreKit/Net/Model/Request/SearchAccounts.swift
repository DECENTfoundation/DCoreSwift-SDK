import Foundation

class SearchAccounts: BaseRequest<[Account]> {
    
    required init(searchTerm: String,
                  order: SearchAccountsOrder = .NAME_DESC,
                  id: ChainObject = ObjectType.nullObject.genericId,
                  limit: Int = 1000) {
        super.init(.database, api: "search_accounts", returnClass: [Account].self, params: [searchTerm, order.rawValue, id, limit])
    }
}
