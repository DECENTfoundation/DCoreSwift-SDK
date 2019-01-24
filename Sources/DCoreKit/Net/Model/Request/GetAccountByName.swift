import Foundation

struct GetAccountByName: BaseRequestConvertible {
    
    typealias Output = Account
    private(set) var base: BaseRequest<Account>
    
    init(_ name: String) {
        
        precondition(Account.hasValid(name: name), "Not a valid account name")
        self.base = GetAccountByName.toBase(
            .database,
            api: "get_account_by_name",
            returnType: Account.self,
            params: [name]
        )
    }
}
