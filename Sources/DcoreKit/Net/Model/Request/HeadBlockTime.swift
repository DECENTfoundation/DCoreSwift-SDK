import Foundation

class HeadBlockTime : BaseRequest<Date> {
    
    required init() {
        super.init(.database, api: "head_block_time", returnClass: Date.self)
    }
}
