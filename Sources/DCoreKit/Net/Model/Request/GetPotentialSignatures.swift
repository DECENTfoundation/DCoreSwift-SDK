import Foundation

struct GetPotentialSignatures: BaseRequestConvertible {
    
    typealias Output = [Address]
    private(set) var base: BaseRequest<[Address]>
    
    init<Input>(_ trx: Transaction<Input>) where Input: Operation {
        self.base = GetPotentialSignatures.toBase(
            .database, api: "get_potential_signatures", returnType: [Address].self, params: [trx]
        )
    }
}
