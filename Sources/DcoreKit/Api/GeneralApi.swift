import Foundation
import RxSwift

public final class GeneralApi: BaseApi {

    public func info() -> Single<String> {
        return Info().base.asCoreRequest(api.core)
    }
    
    public func getChainProperties() -> Single<ChainProperty> {
        return GetChainProperties().base.asCoreRequest(api.core)
    }
    
    public func getGlobalProperties() -> Single<GlobalProperty> {
        return GetGlobalProperties().base.asCoreRequest(api.core)
    }
    
    public func getConfig() -> Single<Config> {
        return GetConfig().base.asCoreRequest(api.core)
    }
    
    public func getChainId() -> Single<String> {
        return GetChainId().base.asCoreRequest(api.core)
    }
    
    public func getDynamicGlobalProperties() -> Single<DynamicGlobalProps> {
        return GetDynamicGlobalProps().base.asCoreRequest(api.core)
    }
    
    public func getTimeToMaintenance(time: Date) -> Single<MinerRewardInput> {
        return GetTimeToMaintenance(time).base.asCoreRequest(api.core)
    }
}
