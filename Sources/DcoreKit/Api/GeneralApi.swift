import Foundation
import RxSwift

public final class GeneralApi: BaseApi {

    public func info() -> Single<String> {
        return Info().asCoreRequest(api.core)
    }
    
    public func getChainProperties() -> Single<ChainProperty> {
        return GetChainProperties().asCoreRequest(api.core)
    }
    
    public func getGlobalProperties() -> Single<GlobalProperty> {
        return GetGlobalProperties().asCoreRequest(api.core)
    }
    
    public func getConfig() -> Single<Config> {
        return GetConfig().asCoreRequest(api.core)
    }
    
    public func getChainId() -> Single<String> {
        return GetChainId().asCoreRequest(api.core)
    }
    
    public func getDynamicGlobalProperties() -> Single<DynamicGlobalProps> {
        return GetDynamicGlobalProps().asCoreRequest(api.core)
    }
    
    public func getTimeToMaintenance(time: Date) -> Single<MinerRewardInput> {
        return GetTimeToMaintenance(time: time).asCoreRequest(api.core)
    }
}
