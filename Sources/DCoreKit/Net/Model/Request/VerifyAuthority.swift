import Foundation

struct VerifyAuthority: BaseRequestConvertible {
    
    typealias Output = Bool
    private(set) var base: BaseRequest<Bool>
    
    init<Input>(_ trx: Transaction<Input>) where Input: Operation {
        self.base = VerifyAuthority.toBase(.database, api: "verify_authority", returnType: Bool.self, params: [trx])
    }
}
