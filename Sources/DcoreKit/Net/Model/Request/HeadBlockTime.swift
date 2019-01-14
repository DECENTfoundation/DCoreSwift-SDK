import Foundation

struct HeadBlockTime: BaseRequestConvertible {
    
    typealias Output = Date
    private(set) var base: BaseRequest<Date>
    
    init() {
        self.base = HeadBlockTime.toBase(.database, api: "head_block_time", returnClass: Date.self)
    }
}
