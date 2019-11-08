import Foundation
import RxSwift
import BigInt

public protocol MiningApi: BaseApi {
    /**
     Get miner by account id.
     
     - Parameter id: Account id as `AccountObjectId` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: An `Miner` if exist.
     */
    func get(byAccountId id: AccountObjectIdConvertible) -> Single<Miner>
    
    /**
     Get first 1000 miners by their name to miner account.
     
     - Returns: Map `[String: Miner]` of miners.
     */
    func getAll() -> Single<[String: Miner]>
    
    /**
     Get list of miners by their ids.
     
     - Parameter ids: Miner ids as `MinerObjectId` or `String` format.
   
     - Returns: Array `[Miner]` of miners.
     */
    func getAll(byIds ids: [ObjectIdConvertible]) -> Single<[Miner]>
    
    /**
     Get names and ids for registered miners.
     
     - Parameter bound: Lower bound of the first name.
     - Parameter limit: Max/default `1000`.
    
     - Returns: List of found miner ids.
     */
    func findAllRelative(byLower bound: String, limit: Int) -> Single<[MinerId]>

    /**
     Get the total number of miners registered in DCore.
     
     - Returns: Number of miners.
     */
    func countAllMiners() -> Single<UInt64>
    
    /**
     Get a list of published price feeds by a miner.
     
     - Parameter id: Account id as `AccountObjectId` or `String` format.
     - Parameter limit: Maximum number of price feeds to fetch, max/default `100`.
     
     - Returns: Array of price feeds published by the miner.
     */
    func getAllFeeds(byAccountId id: AccountObjectIdConvertible, limit: UInt64) -> Single<AnyValue>
    
    /**
     Get the number of votes each miner actually has.
     
     - Returns: Array of `[MinerVotes]`, mapping account names to the number of votes.
     */
    func getAllActualVotes() -> Single<[MinerVotes]>
    
    /**
     Given a set of votes, return the objects they are voting for.
     The results will be in the same order as the votes.
     Null will be returned for any vote ids that are not found.
     
     - Parameter ids: Set of votes.
     
     - Returns: Array of `[Miners]`, mapping account names to the number of votes.
     */
    func findAllVotes(byVoteIds ids: [VoteId]) -> Single<[Miner]>
    
    /**
     Get miner voting info list by account that match search expression.
     
     - Parameter expression: Set of votes.
     - Parameter order: Order, default `SearchOrder.MinerVoting.nameDesc`.
     - Parameter id: The object id of the miner to start searching from,
     1.4.* or null when start from beginning, default `nil`,
     as `MinerObjectId` or `String` format.
     - Parameter accountName: Account name or null when searching without account.
     - Parameter onlyMyVotes: When true it selects only votes given by account.
     - Parameter limit: Maximum number of miners info to fetch, max/default `1000`.
     
     - Returns: Array `[MinerVotingInfo]` of miner voting info.
     */
    func findAllVotingInfos(by expression: String,
                            order: SearchOrder.MinerVoting,
                            id: ObjectIdConvertible?,
                            accountName: String?,
                            onlyMyVotes: Bool,
                            limit: Int) -> Single<[MinerVotingInfo]>

    /**
     Get a reward for a miner from the most recent block.
     
     - Parameter num: Block number.
     
     - Returns: Amount of newlgenerated DCT.
     */
    func getNewAssetPerBlock() -> Single<BigInt>
    
    /**
     Get a reward for a miner from a specified block.
     
     - Parameter num: Block number.
     
     - Returns: Amount of generated DCT.
     */
    func getAssetPerBlock(byBlockNum num: UInt64) -> Single<BigInt>
    
    /**
     Create vote for miner operation.
     
     - Parameter ids: The object ids of the miners,
     eg. 1.4.*, as `MinerObjectId` or `String` format.
     - Parameter credentials: Account credentials.
     
     - Returns: `AccountUpdateOperation`.
     */
    func createVote(forMinerIds ids: [ObjectIdConvertible], credentials: Credentials) -> Single<AccountUpdateOperation>
    
    /**
     Make vote for miner.
     
     - Parameter ids: The object ids of the miners,
     eg. 1.4.*, as `MinerObjectId` or `String` format.
     - Parameter credentials: Account credentials.
     
     - Returns: `TransactionConfirmation`.
     */
    func vote(forMinerIds ids: [ObjectIdConvertible], credentials: Credentials) -> Single<TransactionConfirmation>
}

extension MiningApi {
    public func get(byAccountId id: AccountObjectIdConvertible) -> Single<Miner> {
        return Single.deferred {
            return GetMinerByAccount(try id.asAccountObjectId()).base.toResponse(self.api.core)
        }
    }
    
    public func getAll() -> Single<[String: Miner]> {
        return findAllRelative().flatMap { minerIds in
            return self.getAll(byIds: minerIds.map { $0.id }).map { miners in
                return miners.reduce(into: [String: Miner]()) { map, miner in
                    map[minerIds.first(where: { $0.id == miner.id })!.name] = miner
                }
            }
        }
    }
    
    public func getAll(byIds ids: [ObjectIdConvertible]) -> Single<[Miner]> {
        return Single.deferred {
            return GetMiners(try ids.map { try $0.asObjectId() }).base.toResponse(self.api.core)
        }
    }
    
    public func findAllRelative(byLower bound: String = "", limit: Int = 1000) -> Single<[MinerId]> {
        return LookupMinerAccounts(bound, limit: limit).base.toResponse(api.core)
    }
    
    public func countAllMiners() -> Single<UInt64> {
        return GetMinerCount().base.toResponse(api.core)
    }
    
    public func getAllFeeds(byAccountId id: AccountObjectIdConvertible, limit: UInt64 = 100) -> Single<AnyValue> {
        return Single.deferred {
            return GetFeedsByMiner(try id.asAccountObjectId(), count: limit).base.toResponse(self.api.core)
        }
    }
    
    public func getAllActualVotes() -> Single<[MinerVotes]> {
        return GetActualVotes().base.toResponse(api.core)
    }
    
    public func findAllVotes(byVoteIds ids: [VoteId]) -> Single<[Miner]> {
        return LookupVoteIds(ids).base.toResponse(api.core)
    }
    
    public func findAllVotingInfos(by expression: String,
                                   order: SearchOrder.MinerVoting = .nameDesc,
                                   id: ObjectIdConvertible? = nil,
                                   accountName: String? = nil,
                                   onlyMyVotes: Bool = false,
                                   limit: Int = 1000) -> Single<[MinerVotingInfo]> {
        return Single.deferred {
            return SearchMinerVoting(accountName,
                                     searchTerm: expression,
                                     onlyMyVotes: onlyMyVotes,
                                     order: order,
                                     id: try id?.asObjectId(),
                                     limit: limit).base.toResponse(self.api.core)
        }
    }
    
    public func getNewAssetPerBlock() -> Single<BigInt> {
        return GetNewAssetPerBlock().base.toResponse(api.core)
    }
    
    public func getAssetPerBlock(byBlockNum num: UInt64) -> Single<BigInt> {
        return GetAssetPerBlock(num).base.toResponse(api.core)
    }
    
    public func createVote(forMinerIds ids: [ObjectIdConvertible], credentials: Credentials) -> Single<AccountUpdateOperation> {
        return Single.zip(api.account.get(byId: credentials.accountId), getAll(byIds: ids)).map { (account, miners) in
            return AccountUpdateOperation(account, votes: Set(miners.map { $0.voteId }))
        }
    }
    
    public func vote(forMinerIds ids: [ObjectIdConvertible], credentials: Credentials) -> Single<TransactionConfirmation> {
        return createVote(forMinerIds: ids, credentials: credentials).flatMap {
            return self.api.broadcast.broadcastWithCallback($0, keypair: credentials.keyPair)
        }
    }
}

extension ApiProvider: MiningApi {}
