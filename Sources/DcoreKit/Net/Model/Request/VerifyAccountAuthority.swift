import Foundation

class VerifyAccountAuthority: BaseRequest<Bool> {
    
    required init(account: String, keys: [Address]) {
        super.init(.database, api: "verify_account_authority", returnClass: Bool.self, params: [account, keys])
    }
}
