import Foundation

struct VerifyAccountAuthority: BaseRequestConvertible {
    
    typealias Output = Bool
    private(set) var base: BaseRequest<Bool>
    
    init(_ account: String, keys: [Address]) {
        self.base = VerifyAccountAuthority.toBase(
            .database, api: "verify_account_authority", returnType: Bool.self, params: [
                account, keys
            ]
        )
    }
}
