import Foundation
import RxSwift

public final class AssetApi: BaseApi {
 
    public func getAssets(byIds ids: [ChainObject]) -> Single<[Asset]> {
        return GetAssets(ids: ids).toCoreRequest(api.core)
    }
    
    public func getAsset(byId id: ChainObject) -> Single<Asset> {
        return getAssets(byIds: [id]).map({ $0.first! })
    }
    
    public func getAssets(bySymbols symbols: [Asset.Symbol]) -> Single<[Asset]> {
        return LookupAssets(symbols: symbols).toCoreRequest(api.core)
    }
    
    public func getAsset(bySymbol symbol: Asset.Symbol) -> Single<Asset> {
        return getAssets(bySymbols: [symbol]).map({ $0.first! })
    }
    
    public func getAssets(byLowerBound bound: String, limit: Int = 100) -> Single<[Asset]> {
        return ListAssets(lowerBound: bound, limit:limit).toCoreRequest(api.core)
    }
    
    public func priceToDct(amount: AssetAmount) -> Single<AssetAmount> {
        return PriceToDct(amount: amount).toCoreRequest(api.core)
    }
    
    public func getRealSupply() -> Single<RealSupply> {
        return GetRealSupply().toCoreRequest(api.core)
    }
   
}
