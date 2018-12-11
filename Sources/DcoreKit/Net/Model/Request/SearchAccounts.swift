import Foundation

class SearchAccounts: BaseRequest<[Account]> {
    
    required init(searchTerm: String,
                  order: SearchAccountsOrder = .NAME_DESC,
                  id: ChainObject = ObjectType.NULL_OBJECT.genericId,
                  limit: Int = 1000) {
        super.init(api: .DATABASE, method: "search_accounts", returnClass: [Account].self, params: [searchTerm, order, id, limit])
    }
}
