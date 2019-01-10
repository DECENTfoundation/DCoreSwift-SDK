import Foundation

class GetAccountByName: BaseRequest<Account> {
    
    required init(_ name: String) {
        precondition(Account.hasValid(name: name), "not a valid account name")
        super.init(.database, api: "get_account_by_name", returnClass: Account.self, params: [name])
    }
}
