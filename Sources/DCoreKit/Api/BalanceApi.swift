import Foundation
import RxSwift

public protocol BalanceApi: BaseApi {
    /**
     Get account balance by id.
     
     - Parameter id: Account id, eg. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter asset: Asset id, eg. 1.3.*,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: Amount for asset.
     */
    func get(byAccountId id: ChainObjectConvertible, asset: ChainObjectConvertible) -> Single<AssetAmount>
    
    /**
     Get all account balances by id.
     
     - Parameter id: Account id, eg. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter assets: Asset ids, eg. 1.3.*,
     as `ChainObject` or `String` format, default `[]` - all.
     
     - Returns: Array `[AssetAmount]` of amount for different assets.
     */
    func getAll(byAccountId id: ChainObjectConvertible, assets: [ChainObjectConvertible]) -> Single<[AssetAmount]>
    
    /**
     Get account balance by reference (name or id).
     
     - Parameter id: Account id, eg. 1.2.*.
     - Parameter asset: Asset id, eg. 1.3.*,
     as `ChainObject` or `String` format
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: Array `[AssetAmount]` of amount for different assets.
     */
    func get(byReference ref: Account.Reference, asset: ChainObjectConvertible) -> Single<AssetAmount>
    
    /**
     Get all account balances by reference (name or id).
     
     - Parameter id: Account id, eg. 1.2.*.
     - Parameter assets: Asset ids, eg. 1.3.*,
     as `ChainObject` or `String` format, default `[]` - all.
     
     - Returns: Array `[AssetAmount]` of amount for different assets.
     */
    func getAll(byReference ref: Account.Reference, assets: [ChainObjectConvertible]) -> Single<[AssetAmount]>
    
    /**
     Get account balance with asset by id and symbol.
     
     - Parameter id: Account id, eg. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter symbol: Asset symbol, default `Asset.Symbol.dct`.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: `AssetAmountPair` asset pair with amount.
     */
    func getWithAsset(byAccountId id: ChainObjectConvertible, symbol: Asset.Symbol) -> Single<AssetAmountPair>
    
    /**
     Get all account balances with asset by id and symbols.
     
     - Parameter id: Account id, eg. 1.2.*,
     as `ChainObject` or `String` format.
     - Parameter symbols: Asset symbols, eg. `[Asset.Symbol.dct]`.
     
     - Returns: Array `[AssetAmountPair]` of asset pairs with amounts.
     */
    func getAllWithAsset(byAccountId id: ChainObjectConvertible, symbols: [Asset.Symbol]) -> Single<[AssetAmountPair]>

    /**
     Get all account balances with asset by id.
     
     - Parameter id: Account id, eg. 1.2.*,
     as `ChainObject` or `String` format.
     
     - Returns: Array `[AssetAmountPair]` of asset pairs with amounts.
     */
    func getAllWithAsset(byAccountId id: ChainObjectConvertible) -> Single<[AssetAmountPair]>
   
    /**
     Get account balance with asset by reference (id or name) and symbol.
     
     - Parameter ref: Account id or name in string format, eg. 1.2.*.
     - Parameter symbol: Asset symbol, default `Asset.Symbol.dct`.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: `AssetAmountPair` asset pair with amount.
     */
    func getWithAsset(byReference ref: Account.Reference, symbol: Asset.Symbol) -> Single<AssetAmountPair>

    /**
     Get all account balances with asset by reference (id or name).
     
     - Parameter ref: Account id or name in string format, eg. 1.2.*.
     
     - Returns: Array `[AssetAmountPair]` of asset pairs with amounts.
     */
    func getAllWithAsset(byReference ref: Account.Reference) -> Single<[AssetAmountPair]>
    
    /**
     Get all account balances with asset by reference (id or name) and symbols.
     
     - Parameter ref: Account id or name in string format, eg. 1.2.*.
     - Parameter symbols: Asset symbols, eg. `[Asset.Symbol.dct]`.
     
     - Returns: Array `[AssetAmountPair]` of asset pairs with amounts.
     */
    func getAllWithAsset(byReference ref: Account.Reference, symbols: [Asset.Symbol]) -> Single<[AssetAmountPair]>
    
    /**
     Get information about a vesting balances.
     
     - Parameter id: Account id, eg. 1.2.*,
     as `ChainObject` or `String` format.
     
     - Returns: Array `[VestingBalance]` vesting balances with additional information.
     */
    func getAllVesting(byAccountId id: ChainObjectConvertible) -> Single<[VestingBalance]>
}

extension BalanceApi {
    public func get(byAccountId id: ChainObjectConvertible, asset: ChainObjectConvertible) -> Single<AssetAmount> {
        return getAll(byAccountId: id, assets: [asset]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }
    
    public func getAll(byAccountId id: ChainObjectConvertible, assets: [ChainObjectConvertible] = []) -> Single<[AssetAmount]> {
        return Single.deferred {
            return GetAccountBalances(try id.asChainObject(), assets: try assets.map {
                try $0.asChainObject()
            }).base.toResponse(self.api.core)
        }
    }
    
    public func get(byReference ref: Account.Reference, asset: ChainObjectConvertible) -> Single<AssetAmount> {
        return getAll(byReference: ref, assets: [asset]).map { $0.first! }
    }
    
    public func getAll(byReference ref: Account.Reference, assets: [ChainObjectConvertible] = []) -> Single<[AssetAmount]> {
        return Single.deferred {
            if Account.hasValid(name: ref) {
                return GetNamedAccountBalances(ref, assets: try assets.map { try $0.asChainObject() }).base.toResponse(self.api.core)
            }
            
            return self.api.account.get(byReference: ref).flatMap { account in
                return self.getAll(byAccountId: account.id, assets: assets)
            }
        }
    }
    
    public func getWithAsset(byAccountId id: ChainObjectConvertible, symbol: Asset.Symbol = .dct) -> Single<AssetAmountPair> {
        return getAllWithAsset(byAccountId: id, symbols: [symbol]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }

    public func getAllWithAsset(byAccountId id: ChainObjectConvertible) -> Single<[AssetAmountPair]> {
        return self.getAll(byAccountId: id).flatMap { amounts in
            self.api.asset.getAll(byIds: amounts.map { $0.assetId }).map { assets in
                amounts.map { amount in
                    AssetAmountPair(assets.first { $0.id == amount.assetId }!, amount)
                }
            }
        }
    }

    public func getAllWithAsset(byAccountId id: ChainObjectConvertible, symbols: [Asset.Symbol]) -> Single<[AssetAmountPair]> {
        return api.asset.getAll(bySymbols: symbols).flatMap { assets in
            return self.getAll(byAccountId: id, assets: assets.map { $0.id }).map { amounts in
                return amounts.map { amount in
                    return AssetAmountPair(assets.first(where: { $0.id == amount.assetId })!, amount)
                }
            }
        }
    }
    
    public func getWithAsset(byReference ref: Account.Reference, symbol: Asset.Symbol = .dct) -> Single<AssetAmountPair> {
        return api.account.get(byReference: ref).flatMap { account in
            return self.getWithAsset(byAccountId: account.id, symbol: symbol)
        }
    }

    public func getAllWithAsset(byReference ref: Account.Reference) -> Single<[AssetAmountPair]> {
        return api.account.get(byReference: ref).flatMap { account in
            return self.getAllWithAsset(byAccountId: account.id)
        }
    }
    
    public func getAllWithAsset(byReference ref: Account.Reference, symbols: [Asset.Symbol]) -> Single<[AssetAmountPair]> {
        return api.account.get(byReference: ref).flatMap { account in
            return self.getAllWithAsset(byAccountId: account.id, symbols: symbols)
        }
    }
    
    public func getAllVesting(byAccountId id: ChainObjectConvertible) -> Single<[VestingBalance]> {
        return Single.deferred {
            return GetVestingBalances(try id.asChainObject()).base.toResponse(self.api.core)
        }
    }
}

extension ApiProvider: BalanceApi {}
