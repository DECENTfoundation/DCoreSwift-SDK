import Foundation
import RxSwift

public protocol NftApi: BaseApi {
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
