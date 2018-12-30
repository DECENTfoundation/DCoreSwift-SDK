import Foundation

class SearchMinerVoting: BaseRequest<[MinerVotingInfo]> {
    
    required init(accountName: String?,
                  searchTerm: String,
                  onlyMyVotes: Bool = false,
                  order: SearchMinerVotingOrder = .NAME_DESC,
                  id: ChainObject?,
                  limit: Int = 1000) {
        super.init(.database, api: "search_miner_voting", returnClass: [MinerVotingInfo].self, params: [
            accountName ?? "", searchTerm, onlyMyVotes, order.rawValue, id ?? "", limit
        ])
    }
}
