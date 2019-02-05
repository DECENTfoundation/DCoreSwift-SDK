import Foundation
import RxSwift

public protocol AssetApi: BaseApi {
    func getAssets(byIds ids: [ChainObject]) -> Single<[Asset]>
    func getAsset(byId id: ChainObject) -> Single<Asset>
    func getAssets(bySymbols symbols: [Asset.Symbol]) -> Single<[Asset]>
    func getAsset(bySymbol symbol: Asset.Symbol) -> Single<Asset>
    func getAssets(byLowerBound bound: String, limit: Int) -> Single<[Asset]>
    func convertPrice(toDct amount: AssetAmount) -> Single<AssetAmount>
    func getRealSupply() -> Single<RealSupply>
}

extension AssetApi {
    public func getAssets(byIds ids: [ChainObject]) -> Single<[Asset]> {
        return GetAssets(ids).base.toResponse(api.core)
    }
    
    public func getAsset(byId id: ChainObject) -> Single<Asset> {
        return getAssets(byIds: [id]).map({ try $0.first.orThrow(DCoreException.network(.notFound)) })
    }
    
    public func getAssets(bySymbols symbols: [Asset.Symbol]) -> Single<[Asset]> {
        return LookupAssets(symbols).base.toResponse(api.core)
    }
    
    public func getAsset(bySymbol symbol: Asset.Symbol) -> Single<Asset> {
        return getAssets(bySymbols: [symbol]).map({ try $0.first.orThrow(DCoreException.network(.notFound)) })
    }
    
    public func getAssets(byLowerBound bound: String, limit: Int = 100) -> Single<[Asset]> {
        return ListAssets(bound, limit: limit).base.toResponse(api.core)
    }
    
    public func convertPrice(toDct amount: AssetAmount) -> Single<AssetAmount> {
        return PriceToDct(amount).base.toResponse(api.core)
    }
    
    public func getRealSupply() -> Single<RealSupply> {
        return GetRealSupply().base.toResponse(api.core)
    }
}

extension ApiProvider: AssetApi {}
