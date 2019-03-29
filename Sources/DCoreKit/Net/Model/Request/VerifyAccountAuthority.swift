import Foundation

struct VerifyAccountAuthority: BaseRequestConvertible {
    
    typealias Output = Bool
    private(set) var base: BaseRequest<Bool>
    
    init(_ account: String, keys: [Address]) {
        
        precondition(Account.hasValid(name: account) || (try? account.asChainObject().objectType) == .accountObject, "Not valid account object name")
        self.base = VerifyAccountAuthority.toBase(
            .database, api: "verify_account_authority", returnType: Bool.self, params: [
                account, keys
            ]
        )
    }
}
