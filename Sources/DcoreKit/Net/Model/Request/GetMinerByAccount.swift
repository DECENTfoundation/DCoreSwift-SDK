import Foundation


class GetMinerByAccount: BaseRequest<Miner> {
    
    required init(account: ChainObject) {
        super.init(api: .DATABASE, method: "get_miner_by_account", returnClass: Miner.self, params: [account])
    }
}
