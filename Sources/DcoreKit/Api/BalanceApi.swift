import Foundation
import RxSwift

public final class BalanceApi: BaseApi {
    
    public func getBalances(byAccountId id: ChainObject, assets: [ChainObject]) -> Single<[AssetAmount]>  {
        return GetAccountBalances(id, assets: assets).base.asCoreRequest(api.core)
    }
    
    public func getBalance(byAccountId id: ChainObject, asset: ChainObject) -> Single<AssetAmount> {
        return getBalances(byAccountId: id, assets: [asset]).map({ $0.first! })
    }
    
    public func getBalances(byReference ref: String, assets: [ChainObject]) -> Single<[AssetAmount]> {
        return Single.deferred({ [unowned self] in
            if Account.hasValid(name: ref) {
                return GetNamedAccountBalances(ref, assets: assets).base.asCoreRequest(self.api.core)
            }
           
            return self.api.account.getAccount(byReference: ref).flatMap({ [unowned self] account in
                return self.getBalances(byAccountId: account.id, assets: assets)
            })
        })
    }
    
    public func getBalance(byReference ref: String, asset: ChainObject) -> Single<AssetAmount> {
        return getBalances(byReference: ref, assets: [asset]).map({ $0.first! })
    }
    
    public func getBalances(byAccountId id: ChainObject, symbols: [Asset.Symbol]) -> Single<[AssetAmount.Pair]> {
        return api.asset.getAssets(bySymbols: symbols).flatMap({ [unowned self] assets in
            return self.getBalances(byAccountId: id, assets: assets.map({ $0.id })).map({ amounts in
                return amounts.map({ amount in
                    return (asset: assets.first(where: { $0.id == amount.assetId })!, amount: amount)
                })
            })
        })
    }
    
    public func getBalance(byAccountId id: ChainObject, symbol: Asset.Symbol = .dct) -> Single<AssetAmount.Pair> {
        return getBalances(byAccountId: id, symbols: [symbol]).map({ $0.first! })
    }
    
    public func getBalances(byReference ref: String, symbols: [Asset.Symbol]) -> Single<[AssetAmount.Pair]> {
        return api.account.getAccount(byReference: ref).flatMap({ [unowned self] account in
            return self.getBalances(byAccountId: account.id, symbols: symbols)
        })
    }
    
    public func getBalance(byReference ref: String, symbol: Asset.Symbol = .dct) -> Single<AssetAmount.Pair> {
        return api.account.getAccount(byReference: ref).flatMap({ [unowned self] account in
            return self.getBalance(byAccountId: account.id, symbol: symbol)
        })
    }
    
    public func getVestingBalances(byAccountId id: ChainObject) -> Single<[VestingBalance]> {
        return GetVestingBalances(id).base.asCoreRequest(api.core)
    }
}
