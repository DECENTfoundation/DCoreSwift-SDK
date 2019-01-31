import Foundation

struct SearchMinerVoting: BaseRequestConvertible {
    
    typealias Output = [MinerVotingInfo]
    private(set) var base: BaseRequest<[MinerVotingInfo]>
    
    init(_ name: String?,
         searchTerm: String,
         onlyMyVotes: Bool = false,
         order: SearchOrder.MinerVoting = .nameDesc,
         id: ChainObject?,
         limit: Int = 1000) {
        
        self.base = SearchMinerVoting.toBase(
            .database, api: "search_miner_voting", returnType: [MinerVotingInfo].self, params: [
                name, searchTerm, onlyMyVotes, order, id, limit
            ]
        )
    }
}
