import Foundation

class LookupVoteIds: BaseRequest<[Miner]> {
    
    required init(voteIds: [VoteId]) {
        super.init(api: .DATABASE, method: "lookup_vote_ids", returnClass: [Miner].self, params: [voteIds])
    }
}
