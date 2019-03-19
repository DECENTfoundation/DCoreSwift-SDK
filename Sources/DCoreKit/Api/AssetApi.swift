import Foundation
import RxSwift

public protocol AssetApi: BaseApi {
    /**
     Get asset by id.
     
     - Parameter id: Asset id, e.g. 1.3.*,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: `Asset`.
     */
    func get(byId id: ChainObjectConvertible) -> Single<Asset>
    
    /**
     Get all assets by ids.
     
     - Parameter ids: Asset ids, e.g. [1.3.*],
     as `ChainObject` or `String` format.
     
     - Returns: Array `[Asset]` of assets.
     */
    func getAll(byIds ids: [ChainObjectConvertible]) -> Single<[Asset]>
    
    /**
     Get assets by symbol.
     
     - Parameter symbol: Asset symbol, e.g. `Asset.Symbol.dct`.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: `Asset`.
     */
    func get(bySymbol symbol: Asset.Symbol) -> Single<Asset>
    
    /**
     Get all assets by symbols.
     
     - Parameter symbols: Asset symbols, e.g. `[Asset.Symbol.dct]`.
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns:  Array `[Asset]` of assets.
     */
    func getAll(bySymbols symbols: [Asset.Symbol]) -> Single<[Asset]>
    
    /**
     Get assets alphabetically by symbol name.
     
     - Parameter bound: Lower bound of symbol names to retrieve.
     - Parameter limit: Maximum number of assets to fetch,
     default/max `100`.
     
     - Returns:  Array `[Asset]` of assets.
     */
    func findAllRelative(byLowerBound bound: String, limit: Int) -> Single<[Asset]>
    
    /**
     Converts asset into DCT, using actual price feed.
     
     - Parameter amount: Amount with different asset id,
     then DCT (1.3.0).
     
     - Throws: `DCoreException.Network.notFound`
     if account does not exist.
     
     - Returns: `AssetAmount` in DCT.
     */
    func convert(toDct amount: AssetAmount) -> Single<AssetAmount>
    
    /**
     Current core asset supply.

     - Returns: `RealSupply` current supply.
     */
    func getRealSupply() -> Single<RealSupply>
}

extension AssetApi {
    public func get(byId id: ChainObjectConvertible) -> Single<Asset> {
        return getAll(byIds: [id]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }
    
    public func getAll(byIds ids: [ChainObjectConvertible]) -> Single<[Asset]> {
        return Single.deferred {
            return GetAssets(try ids.map { try $0.asChainObject() }).base.toResponse(self.api.core)
        }
    }
    
    public func get(bySymbol symbol: Asset.Symbol) -> Single<Asset> {
        return getAll(bySymbols: [symbol]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }
    
    public func getAll(bySymbols symbols: [Asset.Symbol]) -> Single<[Asset]> {
        return LookupAssets(symbols).base.toResponse(api.core)
    }
    
    public func findAllRelative(byLowerBound bound: String, limit: Int = DCore.Constant.assetLimit) -> Single<[Asset]> {
        return Single.deferred {
            guard limit <= DCore.Constant.assetLimit else {
                return Single.error(DCoreException.unexpected("Asset limit is out of bound: \(DCore.Constant.assetLimit)"))
            }
            return ListAssets(bound, limit: limit).base.toResponse(self.api.core)
        }
        
    }
    
    public func convert(toDct amount: AssetAmount) -> Single<AssetAmount> {
        return PriceToDct(amount).base.toResponse(api.core)
    }
    
    public func getRealSupply() -> Single<RealSupply> {
        return GetRealSupply().base.toResponse(api.core)
    }
}

extension ApiProvider: AssetApi {}
