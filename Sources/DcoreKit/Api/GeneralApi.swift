import Foundation
import RxSwift

public final class GeneralApi: BaseApi {

    public func info() -> Single<String> {
        return Info().toRequest(core: self.api.core)
    }
    
    public func getChainProperties() -> Single<ChainProperty> {
        return GetChainProperties().toRequest(core: self.api.core)
    }
    
    public func getGlobalProperties() -> Single<GlobalProperty> {
        return GetGlobalProperties().toRequest(core: self.api.core)
    }
    
    public func getConfig() -> Single<Config> {
        return GetConfig().toRequest(core: self.api.core)
    }
    
    public func getChainId() -> Single<String> {
        return GetChainId().toRequest(core: self.api.core)
    }
    
    public func getDynamicGlobalProperties() -> Single<DynamicGlobalProps> {
        return GetDynamicGlobalProps().toRequest(core: self.api.core)
    }
    
    public func getTimeToMaintenance(time: Date) -> Single<MinerRewardInput> {
        return GetTimeToMaintenance(time: time).toRequest(core: self.api.core)
    }
}
