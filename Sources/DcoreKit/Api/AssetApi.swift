import Foundation
import RxSwift

public class AssetApi: BaseApi {
 
    public func getAssets(byIds ids: [ChainObject]) -> Single<[Asset]> {
        return GetAssets(ids: ids).toRequest(core: self.api.core)
    }
    
    public func getAsset(byId id: ChainObject) -> Single<Asset> {
        return getAssets(byIds: [id]).map({ $0.first! })
    }
    
    public func lookupAssets(bySymbols symbols: [String]) -> Single<[Asset]> {
        return LookupAssets(symbols: symbols).toRequest(core: self.api.core)
    }
    
    public func lookupAsset(bySymbol symbol: String) -> Single<Asset> {
        return lookupAssets(bySymbols: [symbol]).map({ $0.first! })
    }
    
    public func listAssets(lowerBound: String, limit: Int = 100) -> Single<[Asset]> {
        return ListAssets(lowerBound: lowerBound, limit:limit).toRequest(core: self.api.core)
    }
    
    public func priceToDct(amount: AssetAmount) -> Single<AssetAmount> {
        return PriceToDct(amount: amount).toRequest(core: self.api.core)
    }
    
    public func getRealSupply() -> Single<RealSupply> {
        return GetRealSupply().toRequest(core: self.api.core)
    }
   
}
