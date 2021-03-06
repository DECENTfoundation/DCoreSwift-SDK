import Foundation

struct VerifyAuthority: BaseRequestConvertible {
    
    typealias Output = Bool
    private(set) var base: BaseRequest<Bool>
    
    init(_ trx: Transaction) {
        self.base = VerifyAuthority.toBase(.database, api: "verify_authority", returnType: Bool.self, params: [trx])
    }
}
