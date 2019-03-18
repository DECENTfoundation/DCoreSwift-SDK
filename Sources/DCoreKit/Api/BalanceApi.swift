import Foundation
import RxSwift

public protocol BalanceApi: BaseApi {
    func getBalances(byAccountId id: ChainObject, assets: [ChainObject]) -> Single<[AssetAmount]>
    func getBalance(byAccountId id: ChainObject, asset: ChainObject) -> Single<AssetAmount>
    func getBalances(byReference ref: String, assets: [ChainObject]) -> Single<[AssetAmount]>
    func getBalance(byReference ref: String, asset: ChainObject) -> Single<AssetAmount>
    func getBalances(byAccountId id: ChainObject, symbols: [Asset.Symbol]) -> Single<[AssetAmountPair]>
    func getBalance(byAccountId id: ChainObject, symbol: Asset.Symbol) -> Single<AssetAmountPair>
    func getBalances(byReference ref: String, symbols: [Asset.Symbol]) -> Single<[AssetAmountPair]>
    func getBalance(byReference ref: String, symbol: Asset.Symbol) -> Single<AssetAmountPair>
    func getVestingBalances(byAccountId id: ChainObject) -> Single<[VestingBalance]>
}

extension BalanceApi {
    public func getBalances(byAccountId id: ChainObject, assets: [ChainObject] = []) -> Single<[AssetAmount]> {
        return GetAccountBalances(id, assets: assets).base.toResponse(api.core)
    }
    
    public func getBalance(byAccountId id: ChainObject, asset: ChainObject) -> Single<AssetAmount> {
        return getBalances(byAccountId: id, assets: [asset]).map({ try $0.first.orThrow(DCoreException.network(.notFound)) })
    }
    
    public func getBalances(byReference ref: Account.Reference, assets: [ChainObject] = []) -> Single<[AssetAmount]> {
        return Single.deferred({
            if Account.hasValid(name: ref) {
                return GetNamedAccountBalances(ref, assets: assets).base.toResponse(self.api.core)
            }
            
            return self.api.account.get(byReference: ref).flatMap({ account in
                return self.getBalances(byAccountId: account.id, assets: assets)
            })
        })
    }
    
    public func getBalance(byReference ref: String, asset: ChainObject) -> Single<AssetAmount> {
        return getBalances(byReference: ref, assets: [asset]).map({ $0.first! })
    }
    
    public func getBalances(byAccountId id: ChainObject, symbols: [Asset.Symbol]) -> Single<[AssetAmountPair]> {
        return api.asset.getAssets(bySymbols: symbols).flatMap({ assets in
            return self.getBalances(byAccountId: id, assets: assets.map({ $0.id })).map({ amounts in
                return amounts.map({ amount in
                    return AssetAmountPair(assets.first(where: { $0.id == amount.assetId })!, amount)
                })
            })
        })
    }
    
    public func getBalance(byAccountId id: ChainObject, symbol: Asset.Symbol = .dct) -> Single<AssetAmountPair> {
        return getBalances(byAccountId: id, symbols: [symbol]).map({ try $0.first.orThrow(DCoreException.network(.notFound)) })
    }
    
    public func getBalances(byReference ref: String, symbols: [Asset.Symbol]) -> Single<[AssetAmountPair]> {
        return api.account.get(byReference: ref).flatMap({ account in
            return self.getBalances(byAccountId: account.id, symbols: symbols)
        })
    }
    
    public func getBalance(byReference ref: String, symbol: Asset.Symbol = .dct) -> Single<AssetAmountPair> {
        return api.account.get(byReference: ref).flatMap({ account in
            return self.getBalance(byAccountId: account.id, symbol: symbol)
        })
    }
    
    public func getVestingBalances(byAccountId id: ChainObject) -> Single<[VestingBalance]> {
        return GetVestingBalances(id).base.toResponse(api.core)
    }
}

extension ApiProvider: BalanceApi {}
