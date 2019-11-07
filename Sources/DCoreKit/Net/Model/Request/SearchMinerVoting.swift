import Foundation

struct SearchMinerVoting: BaseRequestConvertible {
    
    typealias Output = [MinerVotingInfo]
    private(set) var base: BaseRequest<[MinerVotingInfo]>
    
    init(_ user: String?,
         searchTerm: String,
         onlyMyVotes: Bool = false,
         order: SearchOrder.MinerVoting = .nameDesc,
         id: MinerObjectId?,
         limit: Int = 1000) {
        
        precondition(user.isNil() || Account.hasValid(name: user!), "Not valid account object name")
        
        self.base = SearchMinerVoting.toBase(
            .database, api: "search_miner_voting", returnType: [MinerVotingInfo].self, params: [
                user, searchTerm, onlyMyVotes, order, id, limit
            ]
        )
    }
}
