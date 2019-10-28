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

     - Returns: Array of `Nft` objects
     */
    func getAll(bySymbols symbols: [String]) -> Single<[Nft]>

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
    func create<T: NftModel>(
        credentials: Credentials,
        symbol: String,
        maxSupply: UInt32,
        fixedMaxSupply: Bool,
        description: String,
        nftModel: T.Type,
        transferable: Bool,
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

    public func create<T: NftModel>(
        credentials: Credentials,
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
                    memo: memo
                ),
                keypair: credentials.keyPair
            )
        }
    }
}

extension ApiProvider: NftApi {}
