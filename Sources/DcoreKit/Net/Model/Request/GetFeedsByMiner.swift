import Foundation

struct GetFeedsByMiner: BaseRequestConvertible {
    
    typealias Output = AnyValue
    private(set) var base: BaseRequest<AnyValue>
    
    init(_ accountId: ChainObject, count: UInt64 = 100) {
        self.base = GetFeedsByMiner.toBase(
            .database, api: "get_feeds_by_miner", returnClass: AnyValue.self, params: [accountId, count]
        )
    }
}
