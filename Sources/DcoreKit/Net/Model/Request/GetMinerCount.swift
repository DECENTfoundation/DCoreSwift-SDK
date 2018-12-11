import Foundation

class GetMinerCount: BaseRequest<UInt64> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_miner_count", returnClass: UInt64.self)
    }
}
