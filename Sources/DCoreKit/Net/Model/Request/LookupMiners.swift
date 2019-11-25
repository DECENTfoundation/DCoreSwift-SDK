import Foundation

struct LookupMiners: BaseRequestConvertible {
    
    typealias Output = [String: MinerObjectId]
    private(set) var base: BaseRequest<[String: MinerObjectId]>
    
    init(_ bound: String, limit: Int = 1000) {
        self.base = LookupMiners.toBase(
            .database,
            api: "lookup_miners",
            returnType: [String: MinerObjectId].self,
            params: [bound, limit]
        )
    }
}
