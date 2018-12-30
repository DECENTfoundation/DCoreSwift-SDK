import Foundation

class GetFeedsByMiner: BaseRequest<AnyValue> {
   
    required init(account: ChainObject, count: UInt64 = 100) {
        super.init(.database, api: "get_feeds_by_miner", returnClass: AnyValue.self, params: [account, count])
    }
}
