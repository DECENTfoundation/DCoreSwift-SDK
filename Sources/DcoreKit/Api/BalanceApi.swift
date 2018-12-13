import Foundation
import RxSwift

public class BalanceApi: BaseApi {
    
    public func getBalance(byAccountId id: ChainObject, assets: [ChainObject] = []) -> Single<[AssetAmount]>  {
        return GetAccountBalances(accountId: id, assets: assets).toRequest(core: self.api.core)
    }
    
    public func getBalance(byAccountId id: ChainObject, asset: ChainObject) -> Single<AssetAmount> {
        return getBalance(byAccountId: id, assets: [asset]).map({ $0.first! })
    }
    
    public func getBalance(byReference ref: String, assets: [ChainObject] = []) -> Single<[AssetAmount]> {
        return Single.deferred({ [unowned self] in
            switch true {
            case Account.isValid(with: ref):
                return GetNamedAccountBalances(account: ref, assets: assets).toRequest(core: self.api.core)
            default:
                return self.api.accountApi.getAccount(byReference: ref).flatMap({ [unowned self] account in
                    return self.getBalance(byAccountId: account.id, assets: assets)
                })
            }
        })
    }
    
    public func getBalance(byReference ref: String, asset: ChainObject) -> Single<AssetAmount> {
        return getBalance(byReference: ref, assets: [asset]).map({ $0.first! })
    }
    
    public func getBalance(byAccountId id: ChainObject, symbols: [String]) -> Single<[(asset: Asset, amount: AssetAmount)]> {
        return api.assetApi.lookupAssets(bySymbols: symbols).flatMap({ [unowned self] assets in
            return self.getBalance(byAccountId: id, assets: assets.map({ $0.id })).map({ amounts in
                return amounts.map({ amount in
                    return (asset: assets.first(where: { $0.id == amount.assetId })!, amount: amount)
                })
            })
        })
    }
    
    public func getBalance(byAccountId id: ChainObject, symbol: String = DCore.Constants.Symbols.DCT) -> Single<(asset: Asset, amount: AssetAmount)> {
        return getBalance(byAccountId: id, symbols: [symbol]).map({ $0.first! })
    }
    
    public func getBalance(byReference ref: String, symbols: [String]) -> Single<[(asset: Asset, amount: AssetAmount)]> {
        return api.accountApi.getAccount(byReference: ref).flatMap({ [unowned self] account in
            return self.getBalance(byAccountId: account.id, symbols: symbols)
        })
    }
    
    public func getBalance(byReference ref: String, symbol: String = DCore.Constants.Symbols.DCT) -> Single<(asset: Asset, amount: AssetAmount)> {
        return api.accountApi.getAccount(byReference: ref).flatMap({ [unowned self] account in
            return self.getBalance(byAccountId: account.id, symbol: symbol)
        })
    }
    
    public func getVestingBalances(byAccountId id: ChainObject) -> Single<[VestingBalance]> {
        return GetVestingBalances(accountId: id).toRequest(core: self.api.core)
    }
}
