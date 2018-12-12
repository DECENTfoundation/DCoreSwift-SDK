import Foundation

class VerifyAuthority: BaseRequest<Bool> {
    
    required init(transaction: Transaction) {
        super.init(api: .DATABASE, method: "verify_authority", returnClass: Bool.self, params: [transaction])
    }
}
