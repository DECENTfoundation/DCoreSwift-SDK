import Foundation

struct LookupVoteIds: BaseRequestConvertible {
    
    typealias Output = [Miner]
    private(set) var base: BaseRequest<[Miner]>
    
    init(_ ids: [VoteId]) {
        self.base = LookupVoteIds.toBase(.database, api: "lookup_vote_ids", returnType: [Miner].self, params: [ids])
    }
}
