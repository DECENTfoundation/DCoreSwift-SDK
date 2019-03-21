import Foundation
import RxSwift
import BigInt

public protocol AssetApi: BaseApi {
    /**
     Get asset by id.
     
     - Parameter id: Asset id, eg. 1.3.*,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if asset does not exist.
     
     - Returns: `Asset`.
     */
    func get(byId id: ChainObjectConvertible) -> Single<Asset>
    
    /**
     Get all assets by ids.
     
     - Parameter ids: Asset ids, eg. [1.3.*],
     as `ChainObject` or `String` format.
     
     - Returns: Array `[Asset]` of assets.
     */
    func getAll(byIds ids: [ChainObjectConvertible]) -> Single<[Asset]>
    
    /**
     Get assets by symbol.
     
     - Parameter symbol: Asset symbol, eg. `Asset.Symbol.dct`.
     
     - Throws: `DCoreException.Network.notFound`
     if asset does not exist.
     
     - Returns: `Asset`.
     */
    func get(bySymbol symbol: Asset.Symbol) -> Single<Asset>
    
    /**
     Get all assets by symbols.
     
     - Parameter symbols: Asset symbols, eg. `[Asset.Symbol.dct]`.
     
     - Throws: `DCoreException.Network.notFound`
     if asset does not exist.
     
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
    func findAllRelative(byLower bound: String, limit: Int) -> Single<[Asset]>
    
    /**
     Current core asset supply.

     - Returns: `RealSupply` current supply.
     */
    func getRealSupply() -> Single<RealSupply>
    
    /**
     Get asset dynamic data by id.
     
     - Parameter id: Asset dynamic data id, eg. DCT id is 2.3.0,
     as `ChainObject` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if asset data does not exist.
     
     - Returns: Array `[AssetData]` of asset data.
     */
    func getData(byAssetId id: ChainObjectConvertible) -> Single<AssetData>
    
    /**
     Get all asset dynamic data by ids.
     
     - Parameter ids: Asset dynamic data ids, eg. DCT id is 2.3.0,
     as `ChainObject` or `String` format.
     
     - Returns: Array `[AssetData]` of asset data.
     */
    func getAllData(byAssetIds ids: [ChainObjectConvertible]) -> Single<[AssetData]>
    
    /**
     Converts DCT amount to asset by id.
     
     - Parameter amount: Amount in DCT (1.3.0).
     - Parameter assetId: Asset id, different then DCT (1.3.0).
     - Parameter rounding: Rounding mode for division operation.
     
     - Throws: `DCoreException.Network.notFound`
     if asset does not exist or `DCoreException.Chain.failConvert`
     if failed to convert.
     
     - Returns: `AssetAmount` in DCT.
     */
    func convert(fromDct amount: BigInt, to assetId: ChainObjectConvertible, rounding: Decimal.RoundingMode) -> Single<AssetAmount>
    
    /**
     Converts from asset by id to DCT.
     
     - Parameter amount: Amount with different asset id, then DCT (1.3.0).
     - Parameter assetId: Asset id of amount, then DCT (1.3.0).
     - Parameter rounding: Rounding mode for division operation.
     
     - Throws: `DCoreException.Network.notFound`
     if asset does not exist or `DCoreException.Chain.failConvert`
     if failed to convert.
     
     - Returns: `AssetAmount` in DCT.
     */
    func convert(toDct amount: BigInt, from assetId: ChainObjectConvertible, rounding: Decimal.RoundingMode) -> Single<AssetAmount>
    
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
    
    public func findAllRelative(byLower bound: String, limit: Int = DCore.Limits.asset) -> Single<[Asset]> {
        return Single.deferred {
            return ListAssets(bound, limit: try limit.limited(by: DCore.Limits.asset))
                .base
                .toResponse(self.api.core)
        }
        
    }
    
    public func getRealSupply() -> Single<RealSupply> {
        return GetRealSupply().base.toResponse(api.core)
    }
    
    public func getData(byAssetId id: ChainObjectConvertible) -> Single<AssetData> {
        return getAllData(byAssetIds: [id]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }
    
    public func getAllData(byAssetIds ids: [ChainObjectConvertible]) -> Single<[AssetData]> {
        return Single.deferred {
            return GetAssetsData(try ids.map { try $0.asChainObject() }).base.toResponse(self.api.core)
        }
    }
    
    public func convert(fromDct amount: BigInt, to assetId: ChainObjectConvertible, rounding: Decimal.RoundingMode) -> Single<AssetAmount> {
        return get(byId: assetId).map { try $0.convert(fromDct: amount, rounding: rounding) }
    }
    
    public func convert(toDct amount: BigInt, from assetId: ChainObjectConvertible, rounding: Decimal.RoundingMode) -> Single<AssetAmount> {
        return get(byId: assetId).map { try $0.convert(toDct: amount, rounding: rounding) }
    }
}

extension ApiProvider: AssetApi {}
