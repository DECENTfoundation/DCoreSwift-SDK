import Foundation
import RxSwift
import BigInt

public protocol AssetApi: BaseApi {
    /**
     Get asset by id.
     
     - Parameter id: Asset id, eg. 1.3.*,
     as `AssetObjectId` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if asset does not exist.
     
     - Returns: `Asset`.
     */
    func get(byId id: ObjectIdConvertible) -> Single<Asset>
    
    /**
     Get all assets by ids.
     
     - Parameter ids: Asset ids, eg. [1.3.*],
     as `AssetObjectId` or `String` format.
     
     - Returns: Array `[Asset]` of assets.
     */
    func getAll(byIds ids: [ObjectIdConvertible]) -> Single<[Asset]>
    
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
     as `AssetDataObjectId` or `String` format.
     
     - Throws: `DCoreException.Network.notFound`
     if asset data does not exist.
     
     - Returns: `AssetData` of asset data.
     */
    func getData(byAssetDataId id: ObjectIdConvertible) -> Single<AssetData>
    
    /**
     Get all asset dynamic data by ids.
     
     - Parameter ids: Asset dynamic data ids, eg. DCT id is 2.3.0,
     as `AssetDataObjectId` or `String` format.
     
     - Returns: Array `[AssetData]` of asset data.
     */
    func getAllData(byAssetDataIds ids: [ObjectIdConvertible]) -> Single<[AssetData]>
    
    /**
     Converts DCT amount to asset by id,
     conversion is done via `Decimal` with rounding mode.
     
     - Parameter amount: Amount in DCT (1.3.0).
     - Parameter assetId: Asset id, different then DCT (1.3.0).
     - Parameter rounding: Rounding mode for division operation.
     
     - Throws: `DCoreException.Network.notFound`
     if asset does not exist or `DCoreException.Chain.failConvert`
     if failed to convert.
     
     - Returns: `AssetAmount` in DCT.
     */
    func convert(fromDct amount: BigInt, to assetId: ObjectIdConvertible, rounding: Decimal.RoundingMode) -> Single<AssetAmount>
    
    /**
     Converts from asset by id to DCT,
     conversion is done via `Decimal` with rounding mode.
     
     - Parameter amount: Amount with different asset id, then DCT (1.3.0).
     - Parameter assetId: Asset id of amount, then DCT (1.3.0).
     - Parameter rounding: Rounding mode for division operation.
     
     - Throws: `DCoreException.Network.notFound`
     if asset does not exist or `DCoreException.Chain.failConvert`
     if failed to convert.
     
     - Returns: `AssetAmount` in DCT.
     */
    func convert(toDct amount: BigInt, from assetId: ObjectIdConvertible, rounding: Decimal.RoundingMode) -> Single<AssetAmount>

    /**
     Check if the asset exists.
     
     - Parameter symbol: Asset symbol.
     
     - Returns: `true` if asset exist.
     */
    func exist(bySymbol symbol: Asset.Symbol) -> Single<Bool>

    /**
     Create asset.
     
     - Parameter credentials: account credentials issuing the asset.
     - Parameter symbol: the string symbol, 3-16 uppercase chars.
     - Parameter precision: base unit precision, decimal places used in string representation.
     - Parameter description: optional description
     - Parameter options: asset options
     - Parameter fee: `AssetAmount` fee for the operation,
     if left `AssetAmount.unset` the fee will be computed in DCT asset,
     default `AssetAmount.unset`.
     
     - Throws: `DCoreException.Network.alreadyFound`
     if asset with given symbol already exists.
     
     - Returns: `TransactionConfirmation` that asset was created.
     */
    func create(
        credentials: Credentials,
        symbol: String,
        precision: UInt8,
        description: String,
        options: Asset.Options,
        fee: AssetAmount
    ) -> Single<TransactionConfirmation>
    
}

extension AssetApi {
    public func get(byId id: ObjectIdConvertible) -> Single<Asset> {
        return getAll(byIds: [id]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }
    
    public func getAll(byIds ids: [ObjectIdConvertible]) -> Single<[Asset]> {
        return Single.deferred {
            return GetAssets(try ids.map { try $0.asObjectId() }).base.toResponse(self.api.core)
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
    
    public func getData(byAssetDataId id: ObjectIdConvertible) -> Single<AssetData> {
        return getAllData(byAssetDataIds: [id]).map {
            try $0.first.orThrow(DCoreException.network(.notFound))
        }
    }
    
    public func getAllData(byAssetDataIds ids: [ObjectIdConvertible]) -> Single<[AssetData]> {
        return Single.deferred {
            return GetAssetsData(try ids.map { try $0.asObjectId() }).base.toResponse(self.api.core)
        }
    }
    
    public func convert(fromDct amount: BigInt, to assetId: ObjectIdConvertible, rounding: Decimal.RoundingMode) -> Single<AssetAmount> {
        return get(byId: assetId).map { try $0.convert(fromDct: amount, rounding: rounding) }
    }
    
    public func convert(toDct amount: BigInt, from assetId: ObjectIdConvertible, rounding: Decimal.RoundingMode) -> Single<AssetAmount> {
        return get(byId: assetId).map { try $0.convert(toDct: amount, rounding: rounding) }
    }

    public func exist(bySymbol symbol: Asset.Symbol) -> Single<Bool> {
        return get(bySymbol: symbol).map({ _ in true }).catchErrorJustReturn(false)
    }

    public func create(
        credentials: Credentials,
        symbol: String,
        precision: UInt8,
        description: String,
        options: Asset.Options = Asset.Options(
            maxSupply: BigInt(DCore.Constant.maxShareSupply),
            exchangeRate: Asset.ExchangeRate.forCreateOperation(dct: 1, uia: 1),
            exchangeable: true,
            extensions: Asset.Options.FixedMaxSupply(isFixedMaxSupply: false)
        ),
        fee: AssetAmount = .unset
    ) -> Single<TransactionConfirmation> {
        return exist(bySymbol: Asset.Symbol.from(symbol)).flatMap { result in
            guard !result else { return Single.error(DCoreException.network(.alreadyFound)) }
            return self.api.broadcast.broadcastWithCallback(
                AssetCreateOperation(
                    issuer: credentials.accountId,
                    symbol: symbol,
                    precision: precision,
                    description: description,
                    options: options,
                    monitoredOptions: nil,
                    fee: fee
                ),
                keypair: credentials.keyPair
            )
        }
    }
}

extension ApiProvider: AssetApi {}
