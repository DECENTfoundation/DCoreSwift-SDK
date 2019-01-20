import Foundation

struct GetRequiredSignatures: BaseRequestConvertible {
    
    typealias Output = [Address]
    private(set) var base: BaseRequest<[Address]>
    
    init<Input>(_ trx: Transaction<Input>, keys: [Address]) where Input: Operation {
        self.base = GetRequiredSignatures.toBase(
            .database,
            api: "get_required_signatures",
            returnType: [Address].self,
            params: [trx, keys]
        )
    }
}
