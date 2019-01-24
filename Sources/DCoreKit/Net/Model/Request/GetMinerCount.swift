import Foundation

struct GetMinerCount: BaseRequestConvertible {
    
    typealias Output = UInt64
    private(set) var base: BaseRequest<UInt64>
    
    init() {
        self.base = GetMinerCount.toBase(.database, api: "get_miner_count", returnType: UInt64.self)
    }
}
