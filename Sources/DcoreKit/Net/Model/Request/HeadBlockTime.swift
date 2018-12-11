import Foundation

class HeadBlockTime : BaseRequest<Date> {
    
    required init() {
        super.init(api: .DATABASE, method: "head_block_time", returnClass: Date.self)
    }
}
