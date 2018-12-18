import Foundation
import RxSwift
import BigInt

public final class MiningApi: BaseApi {
    
    public func getNewAssetPerBlock() -> Single<BigInt> {
        return GetNewAssetPerBlock().toRequest(core: self.api.core)
    }

    public func getAssetPerBlock(byBlockNum num: UInt64) -> Single<BigInt> {
        return GetAssetPerBlock(blockNum: num).toRequest(core: self.api.core)
    }
    
    public func getMiners(byIds ids: [ChainObject]) -> Single<[Miner]> {
        return GetMiners(minerIds: ids).toRequest(core: self.api.core)
    }
    
    public func getMiner(byAccountId id: ChainObject) -> Single<Miner> {
        return GetMinerByAccount(account: id).toRequest(core: self.api.core)
    }
    
    public func lookupMiners(byTerm term: String = "", limit: Int = 1000) -> Single<[MinerId]> {
        return LookupMinerAccounts(lookupTerm: term, limit: limit).toRequest(core: self.api.core)
    }

    public func getMinerCount() -> Single<UInt64> {
        return GetMinerCount().toRequest(core: self.api.core)
    }
    

    public func getFeedsByMiner(byAccountId id: ChainObject, count: UInt64 = 100) -> Single<AnyValue> {
        return GetFeedsByMiner(account: id, count: count).toRequest(core: self.api.core)
    }
    
    public func lookupVoteIds(byVoteIds ids: [VoteId]) -> Single<[Miner]> {
        return LookupVoteIds(voteIds: ids).toRequest(core: self.api.core)
    }
    
    public func getActualVotes() -> Single<[MinerVotes]> {
        return GetActualVotes().toRequest(core: self.api.core)
    }

    public func search(minerVotingByTerm term: String,
                       order: SearchMinerVotingOrder = .NAME_DESC,
                       id: ChainObject? = nil,
                       accountName: String? = nil,
                       onlyMyVotes: Bool = false,
                       limit: Int = 1000) -> Single<[MinerVotingInfo]> {
        
        return SearchMinerVoting(accountName: accountName, searchTerm: term, onlyMyVotes: onlyMyVotes, order: order, id: id, limit: limit).toRequest(core: self.api.core)
    }
 
    public func getMiners() -> Single<[String:Miner]> {
        return self.lookupMiners().flatMap({ [unowned self] minerIds in
            return self.getMiners(byIds: minerIds.map({ $0.id })).map({ miners in
                return miners.reduce(into: [String:Miner](), { map, miner in
                    map[minerIds.first(where: { $0.id == miner.id })!.name] = miner
                })
            })
        })
    }
}
