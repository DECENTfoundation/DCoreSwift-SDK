import Foundation

struct GetRequiredSignatures: BaseRequestConvertible {
    
    typealias Output = [Address]
    private(set) var base: BaseRequest<[Address]>
    
    init(_ trx: Transaction, keys: [Address]) {
        self.base = GetRequiredSignatures.toBase(
            .database,
            api: "get_required_signatures",
            returnClass: [Address].self,
            params: [trx, keys]
        )
    }
}
