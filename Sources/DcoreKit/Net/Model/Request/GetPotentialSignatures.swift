import Foundation

struct GetPotentialSignatures: BaseRequestConvertible {
    
    typealias Output = [Address]
    private(set) var base: BaseRequest<[Address]>
    
    init(_ trx: Transaction) {
        self.base = GetPotentialSignatures.toBase(
            .database, api: "get_potential_signatures", returnClass: [Address].self, params: [trx]
        )
    }
}
