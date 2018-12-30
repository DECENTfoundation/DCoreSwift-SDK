import Foundation

class GetAccountByName: BaseRequest<Account> {
    
    required init(_ name: String) {
        guard Account.hasValid(name: name) else { preconditionFailure("not a valid account name") }
        super.init(.database, api: "get_account_by_name", returnClass: Account.self, params: [name])
    }
}
