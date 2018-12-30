import Foundation

class VerifyAuthority: BaseRequest<Bool> {
    
    required init(transaction: Transaction) {
        super.init(.database, api: "verify_authority", returnClass: Bool.self, params: [transaction])
    }
}
