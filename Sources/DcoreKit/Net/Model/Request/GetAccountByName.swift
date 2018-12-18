import Foundation

class GetAccountByName: BaseRequest<Account> {
    
    required init(name: String) {
        guard Account.hasValid(name: name) else { preconditionFailure("not a valid account name") }
        super.init(api: .DATABASE, method: "get_account_by_name", returnClass: Account.self, params: [name])
    }
}
