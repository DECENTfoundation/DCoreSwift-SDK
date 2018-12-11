import Foundation

class GetFeedsByMiner: BaseRequest<[Any]> {
   
    required init(account: ChainObject, count: UInt64 = 100) {
        super.init(api: .DATABASE, method: "get_feeds_by_miner", returnClass: [Any].self, params: [account, count])
    }
}
