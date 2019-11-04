import Foundation
import RxSwift

public protocol NftApi: BaseApi {
    /**
     Get NFT by id.
     
     - Parameter id: NFT object id,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if NFT does not exist.
     
     - Returns: `Nft`.
     */
    func get(byId id: ChainObjectConvertible) -> Single<Nft>

    /**
     Get NFTs by id.

     - Parameter ids: NFT object ids,
     as `ChainObject` or `String` format.

     - Returns: Array of `Nft` objects
     */
    func getAll(byIds ids: [ChainObjectConvertible]) -> Single<[Nft]>

    /**
     Get NFT by reference.
     
     - Parameter reference: NFT object id or symbol,
     as `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if NFT does not exist.
     
     - Returns: `Nft`.
     */
    func get(byReference reference: Nft.Reference) -> Single<Nft>

    /**
     Get NFT by symbol.
     
     - Parameter symbol: NFT symbol,
     as `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if NFT does not exist.
     
     - Returns: `Nft`.
     */
    func get(bySymbol symbol: String) -> Single<Nft>

    /**
     Get NFTs by references.

     - Parameter symbols: NFT symbols,
     as `String` format.

     - Returns: Array of `Nft` objects.
     */
    func getAll(bySymbols symbols: [String]) -> Single<[Nft]>

    /**
     Get NFTs alphabetically by symbol name

     - Parameter bound: lower bound of symbol names to retrieve
     - Parameter limit: maximum number of NFTs to fetch (must not exceed 100)

     - Returns: Array of found `Nft` objects.
     */
    func listAllRelative(byLower bound: String, limit: Int) -> Single<[Nft]>

    /**
     Get NFT data instance with raw model.
     
     - Parameter id: NFT data object id,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if NFT does not exist.
     
     - Returns: `NftData<RawNft>` object.
     */
    func getDataRaw(byId id: ChainObjectConvertible) -> Single<NftData<RawNft>>

    /**
     Get NFT data instances with raw model.
     
     - Parameter ids: NFT data object ids,
     as `ChainObject` or `String` format.
     
     - Returns: Array of `NftData<RawNft>` objects.
     */
    func getAllDataRaw(byIds ids: [ChainObjectConvertible]) -> Single<[NftData<RawNft>]>

    /**
     Get NFT data instance with parsed model.
     
     - Parameter id: NFT data object id,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if NFT does not exist.
     
     - Returns: `NftData` object.
     */
    func getData<T: NftModel>(byId id: ChainObjectConvertible) -> Single<NftData<T>>

    /**
     Get NFT data instances with parsed model.
     
     - Parameter ids: NFT data object ids,
     as `ChainObject` or `String` format.
     
     - Returns: Array of `NftData` objects.
     */
    func getAllData<T: NftModel>(byIds ids: [ChainObjectConvertible]) -> Single<[NftData<T>]>

    /**
     Get NFT data instances with raw model.

     - Parameter nftId: NFT object id
     as `ChainObject` or `String` format.

     - Returns: Array of `NftData<RawNft>` objects.
     */
    func listDataRaw(byNftId nftId: ChainObjectConvertible) -> Single<[NftData<RawNft>]>

    /**
     Get NFT data instances with parsed model.

     - Parameter nftId: NFT object id
     as `ChainObject` or `String` format.

     - Returns: Array of `NftData` objects.
     */
    func listData<T: NftModel>(byNftId nftId: ChainObjectConvertible) -> Single<[NftData<T>]>

    /**
     Search NFT history, lists transfer and issue operations for NFT data instance object id.

     - Parameter nftDataId: NFT data object id,
     as `ChainObject` or `String` format.

     - Returns: Array of `TransactionDetail` objects representing transfer and issue operations.
     */
    func searchNftHistory(byNftDataId nftDataId: ChainObjectConvertible) -> Single<[TransactionDetail]>

    /**
     Count all NFTs

     - Returns: count of NFT definitions
     */
    func countAllNft() -> Single<UInt64>

    /**
     Count all NFT data instances

     - Returns: count of NFT data instances
     */
    func countAllNftData() -> Single<UInt64>

    /**
     Get NFT balances per account with raw model

     - Parameter account: Account object id,
     as `ChainObject` or `String` format.
     - Parameter nftIds: NFT object ids to filter, or empty list to fetch all,
     as `ChainObject` or `String` format.

     - Returns: NFT data instances with raw model
     */
    func getNftBalancesRaw(
        account: ChainObjectConvertible, nftIds: [ChainObjectConvertible]) -> Single<[NftData<RawNft>]>

    /**
     Get NFT balances per account with parsed model

     - Parameter account: Account object id,
     as `ChainObject` or `String` format.
     - Parameter nftIds: NFT object ids to filter, or empty list to fetch all,
     as `ChainObject` or `String` format.

     - Returns: NFT data instances with parsed model
     */
    func getNftBalances<T: NftModel>(
        account: ChainObjectConvertible, nftIds: [ChainObjectConvertible]) -> Single<[NftData<T>]>

    /**
     Create NFT.
     
     - Parameter credentials: account credentials issuing the NFT.
     - Parameter symbol: NFT symbol.
     - Parameter maxSupply: NFT max suppy.
     - Parameter fixedMaxSupply: NFT max supply is fixed and cannot be changed with update.
     - Parameter description: text description.
     - Parameter nftModel: NFT model reference.
     - Parameter transferable: allow transfer of NFT data instances to other accounts.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Returns: `TransactionConfirmation` that NFT was created.
     */
    // swiftlint:disable:next function_parameter_count
    func create<T: NftModel>(credentials: Credentials,
                             symbol: String,
                             maxSupply: UInt32,
                             fixedMaxSupply: Bool,
                             description: String,
                             nftModel: T.Type,
                             transferable: Bool,
                             fee: AssetAmount) -> Single<TransactionConfirmation>

    /**
     Update NFT

     - Parameter credentials: issuer account credentials.
     - Parameter reference: NFT object id or symbol.
     - Parameter maxSupply: update NFT max suppy.
     - Parameter fixedMaxSupply: update NFT max supply is fixed.
     - Parameter description: update text description.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Returns: `TransactionConfirmation` that NFT was updated.
     */
    func update(credentials: Credentials,
                reference: Nft.Reference,
                maxSupply: UInt32?,
                fixedMaxSupply: Bool?,
                description: String?,
                fee: AssetAmount) -> Single<TransactionConfirmation>

    /**
     Update NFT data instance

     - Parameter credentials: issuer account credentials.
     - Parameter id: NFT data object id,
     as `ChainObject` or `String` format.
     - Parameter newData: data model with values.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.

     - Returns: `TransactionConfirmation` that NFT data instance was updated.
     */
    func updateData<T: NftModel>(credentials: Credentials,
                                 id: ChainObjectConvertible,
                                 newData: T,
                                 fee: AssetAmount) -> Single<TransactionConfirmation>

    /**
     Issue NFT. Creates a NFT data instance.
     
     - Parameter credentials: account credentials issuing the NFT.
     - Parameter reference: NFT object id or symbol.
     - Parameter to: account object id receiving the NFT data instance
     as `ChainObject` or `String` format.
     - Parameter data: data model with values.
     - Parameter memo: optional message.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Returns: `TransactionConfirmation` that NFT was issued.
     */
    func issue<T: NftModel>(
        credentials: Credentials,
        reference: Nft.Reference,
        to: ChainObjectConvertible,
        data: T?,
        memo: Memo?,
        fee: AssetAmount) -> Single<TransactionConfirmation>

    /**
     Transfer NFT data instance.
     
     - Parameter credentials: NFT data instance owner credentials.
     - Parameter to: account object id receiving the NFT data instance
     as `ChainObject` or `String` format.
     - Parameter id: NFT data object id,
     as `ChainObject` or `String` format.
     - Parameter memo: optional message.
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Returns: `TransactionConfirmation` that NFT was transfered.
     */
    func transfer(
        credentials: Credentials,
        to: ChainObjectConvertible,
        id: ChainObjectConvertible,
        memo: Memo?,
        fee: AssetAmount) -> Single<TransactionConfirmation>
}

extension NftApi {
    public func get(byId id: ChainObjectConvertible) -> Single<Nft> {
        return getAll(byIds: [id]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }

    public func getAll(byIds ids: [ChainObjectConvertible]) -> Single<[Nft]> {
        return Single.deferred {
            GetNfts(try ids.map { try $0.asChainObject() }).base.toResponse(self.api.core)
        }
    }

    public func get(byReference reference: Nft.Reference) -> Single<Nft> {
        if let id = reference.dcore.chainObject {
            return get(byId: id)
        } else {
            return get(bySymbol: reference)
        }
    }

    public func get(bySymbol symbol: String) -> Single<Nft> {
        return getAll(bySymbols: [symbol]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }

    public func getAll(bySymbols symbols: [String]) -> Single<[Nft]> {
        return Single.deferred {
            GetNftsBySymbol(symbols).base.toResponse(self.api.core)
        }
    }

    public func listAllRelative(byLower bound: String, limit: Int = DCore.Limits.nft) -> Single<[Nft]> {
        return Single.deferred {
            ListNfts(bound, limit: limit).base.toResponse(self.api.core)
        }
    }

    public func getDataRaw(byId id: ChainObjectConvertible) -> Single<NftData<RawNft>> {
        return getAllDataRaw(byIds: [id]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }

    public func getAllDataRaw(byIds ids: [ChainObjectConvertible]) -> Single<[NftData<RawNft>]> {
        return Single.deferred {
            GetNftData(try ids.map { try $0.asChainObject() }).base.toResponse(self.api.core)
        }
    }

    public func getData<T: NftModel>(byId id: ChainObjectConvertible) -> Single<NftData<T>> {
        return getAllData(byIds: [id]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }

    public func getAllData<T: NftModel>(byIds ids: [ChainObjectConvertible]) -> Single<[NftData<T>]> {
        return getAllDataRaw(byIds: ids).map { try $0.toParsedNftData() }
    }

    public func listDataRaw(byNftId nftId: ChainObjectConvertible) -> Single<[NftData<RawNft>]> {
        return Single.deferred {
            ListNftData(try nftId.asChainObject()).base.toResponse(self.api.core)
        }
    }

    public func listData<T: NftModel>(byNftId nftId: ChainObjectConvertible) -> Single<[NftData<T>]> {
        return listDataRaw(byNftId: nftId).map { try $0.toParsedNftData() }
    }

    public func searchNftHistory(byNftDataId nftDataId: ChainObjectConvertible) -> Single<[TransactionDetail]> {
        return Single.deferred { SearchNftHistory(try nftDataId.asChainObject()).base.toResponse(self.api.core) }
    }

    public func countAllNft() -> Single<UInt64> {
        return Single.deferred { GetNftCount().base.toResponse(self.api.core) }
    }

    public func countAllNftData() -> Single<UInt64> {
        return Single.deferred { GetNftDataCount().base.toResponse(self.api.core) }
    }

    public func getNftBalancesRaw(
        account: ChainObjectConvertible, nftIds: [ChainObjectConvertible] = []) -> Single<[NftData<RawNft>]> {
        return Single.deferred {
            GetNftsBalances(try account.asChainObject(), try nftIds.map { try $0.asChainObject() })
                .base.toResponse(self.api.core)
        }
    }

    public func getNftBalances<T: NftModel>(
        account: ChainObjectConvertible, nftIds: [ChainObjectConvertible] = []) -> Single<[NftData<T>]> {
        return getNftBalancesRaw(account: account, nftIds: nftIds).map { try $0.toParsedNftData() }
    }

    // swiftlint:disable:next function_parameter_count
    public func create<T: NftModel>(credentials: Credentials,
                                    symbol: String,
                                    maxSupply: UInt32,
                                    fixedMaxSupply: Bool,
                                    description: String,
                                    nftModel: T.Type,
                                    transferable: Bool,
                                    fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return Single.deferred {
            self.api.broadcast.broadcastWithCallback(
                NftCreateOperation(
                    symbol: symbol,
                    options: NftOptions(
                        issuer: credentials.accountId,
                        maxSupply: maxSupply,
                        fixedMaxSupply: fixedMaxSupply,
                        description: description),
                    definitions: nftModel.init().createDefinitions(),
                    transferable: transferable,
                    fee: fee
                ),
                keypair: credentials.keyPair
            )
        }
    }

    public func update(credentials: Credentials,
                       reference: Nft.Reference,
                       maxSupply: UInt32? = nil,
                       fixedMaxSupply: Bool? = nil,
                       description: String? = nil,
                       fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return get(byReference: reference).flatMap { nft in
            self.api.broadcast.broadcastWithCallback(
                NftUpdateOperation(
                    issuer: credentials.accountId,
                    nftId: nft.id,
                    options: nft.options.updated(
                        byMaxSupply: maxSupply, fixedMaxSupply: fixedMaxSupply, description: description),
                    fee: fee
                ),
                keypair: credentials.keyPair
            )
        }
    }

    public func updateData<T: NftModel>(credentials: Credentials,
                                        id: ChainObjectConvertible,
                                        newData: T,
                                        fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return Single.deferred {
            self.api.broadcast.broadcastWithCallback(
                NftUpdateDataOperation(
                    modifier: credentials.accountId,
                    nftDataId: try id.asChainObject(),
                    data: try newData.createUpdate(),
                    fee: fee
                ),
                keypair: credentials.keyPair
            )
        }
    }

    public func issue<T: NftModel>(
        credentials: Credentials,
        reference: Nft.Reference,
        to: ChainObjectConvertible,
        data: T? = nil,
        memo: Memo? = nil,
        fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return get(byReference: reference).flatMap { nft in
            self.api.broadcast.broadcastWithCallback(
                NftIssueOperation(
                    issuer: credentials.accountId,
                    nftId: nft.id,
                    to: try to.asChainObject(),
                    data: (try data?.values()).or([]),
                    memo: memo,
                    fee: fee
                ),
                keypair: credentials.keyPair
            )
        }
    }

    public func transfer(
        credentials: Credentials,
        to: ChainObjectConvertible,
        id: ChainObjectConvertible,
        memo: Memo? = nil,
        fee: AssetAmount = .unset) -> Single<TransactionConfirmation> {
        return Single.deferred {
            self.api.broadcast.broadcastWithCallback(
                NftTransferOperation(
                    from: credentials.accountId,
                    to: try to.asChainObject(),
                    nftDataId: try id.asChainObject(),
                    memo: memo,
                    fee: fee
                ),
                keypair: credentials.keyPair
            )
        }
    }
}

extension ApiProvider: NftApi {}

private extension Array where Element == NftData<RawNft> {
    func toParsedNftData<T: NftModel>() throws -> [NftData<T>] {
        try map { rawData -> NftData<T> in
            NftData(
                id: rawData.id,
                nftId: rawData.nftId,
                owner: rawData.owner,
                data: try rawData.data?.toNftModel()
            )
        }
    }
}
