import Foundation

class LookupVoteIds: BaseRequest<[Miner]> {
    
    required init(voteIds: [VoteId]) {
        super.init(.database, api: "lookup_vote_ids", returnClass: [Miner].self, params: [voteIds])
    }
}
