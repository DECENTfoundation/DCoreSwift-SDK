import Foundation

struct LookupMiners: BaseRequestConvertible {
    
    typealias Output = [String: ChainObject]
    private(set) var base: BaseRequest<[String: ChainObject]>
    
    init(_ bound: String, limit: Int = 1000) {
        self.base = LookupMiners.toBase(
            .database,
            api: "lookup_miners",
            returnType: [String: ChainObject].self,
            params: [bound, limit]
        )
    }
}
