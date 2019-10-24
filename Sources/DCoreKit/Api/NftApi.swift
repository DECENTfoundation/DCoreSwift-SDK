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
     Get NFTs by id

     - Parameter ids: NFT object ids,
     as `ChainObject` or `String` format.

     - Returns: Array of `Nft` objects
     */
    func getAll(byIds ids: [ChainObjectConvertible]) -> Single<[Nft]>

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
}

extension ApiProvider: NftApi {}
