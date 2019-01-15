import Foundation
import RxSwift
import BigInt

public protocol MiningApi: BaseApi {
    func getNewAssetPerBlock() -> Single<BigInt>
    func getAssetPerBlock(byBlockNum num: UInt64) -> Single<BigInt>
    func getMiners(byIds ids: [ChainObject]) -> Single<[Miner]>
    func getMiner(byAccountId id: ChainObject) -> Single<Miner>
    func lookupMiners(byTerm term: String, limit: Int) -> Single<[MinerId]>
    func getMinerCount() -> Single<UInt64>
    func getFeedsByMiner(byAccountId id: ChainObject, count: UInt64) -> Single<AnyValue>
    func lookupVoteIds(byVoteIds ids: [VoteId]) -> Single<[Miner]>
    func getActualVotes() -> Single<[MinerVotes]>
    func search(minerVotingByTerm term: String,
                order: SearchOrder.MinerVoting,
                id: ChainObject?,
                accountName: String?,
                onlyMyVotes: Bool,
                limit: Int) -> Single<[MinerVotingInfo]>
    func getMiners() -> Single<[String: Miner]>
}

extension MiningApi {
    public func getNewAssetPerBlock() -> Single<BigInt> {
        return GetNewAssetPerBlock().base.toResponse(api.core)
    }
    
    public func getAssetPerBlock(byBlockNum num: UInt64) -> Single<BigInt> {
        return GetAssetPerBlock(num).base.toResponse(api.core)
    }
    
    public func getMiners(byIds ids: [ChainObject]) -> Single<[Miner]> {
        return GetMiners(ids).base.toResponse(api.core)
    }
    
    public func getMiner(byAccountId id: ChainObject) -> Single<Miner> {
        return GetMinerByAccount(id).base.toResponse(api.core)
    }
    
    public func lookupMiners(byTerm term: String = "", limit: Int = 1000) -> Single<[MinerId]> {
        return LookupMinerAccounts(term, limit: limit).base.toResponse(api.core)
    }
    
    public func getMinerCount() -> Single<UInt64> {
        return GetMinerCount().base.toResponse(api.core)
    }
    
    public func getFeedsByMiner(byAccountId id: ChainObject, count: UInt64 = 100) -> Single<AnyValue> {
        return GetFeedsByMiner(id, count: count).base.toResponse(api.core)
    }
    
    public func lookupVoteIds(byVoteIds ids: [VoteId]) -> Single<[Miner]> {
        return LookupVoteIds(ids).base.toResponse(api.core)
    }
    
    public func getActualVotes() -> Single<[MinerVotes]> {
        return GetActualVotes().base.toResponse(api.core)
    }
    
    public func search(minerVotingByTerm term: String,
                       order: SearchOrder.MinerVoting = .nameDesc,
                       id: ChainObject? = nil,
                       accountName: String? = nil,
                       onlyMyVotes: Bool = false,
                       limit: Int = 1000) -> Single<[MinerVotingInfo]> {
        
        return SearchMinerVoting(accountName,
                                 searchTerm: term,
                                 onlyMyVotes: onlyMyVotes,
                                 order: order,
                                 id: id,
                                 limit: limit).base.toResponse(api.core)
    }
    
    public func getMiners() -> Single<[String: Miner]> {
        return self.lookupMiners().flatMap({ minerIds in
            return self.getMiners(byIds: minerIds.map({ $0.id })).map({ miners in
                return miners.reduce(into: [String: Miner](), { map, miner in
                    map[minerIds.first(where: { $0.id == miner.id })!.name] = miner
                })
            })
        })
    }
}

extension ApiProvider: MiningApi {}
