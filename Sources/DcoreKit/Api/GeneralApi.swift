import Foundation
import RxSwift

public final class GeneralApi: BaseApi {

    public func info() -> Single<String> {
        return Info().toCoreRequest(api.core)
    }
    
    public func getChainProperties() -> Single<ChainProperty> {
        return GetChainProperties().toCoreRequest(api.core)
    }
    
    public func getGlobalProperties() -> Single<GlobalProperty> {
        return GetGlobalProperties().toCoreRequest(api.core)
    }
    
    public func getConfig() -> Single<Config> {
        return GetConfig().toCoreRequest(api.core)
    }
    
    public func getChainId() -> Single<String> {
        return GetChainId().toCoreRequest(api.core)
    }
    
    public func getDynamicGlobalProperties() -> Single<DynamicGlobalProps> {
        return GetDynamicGlobalProps().toCoreRequest(api.core)
    }
    
    public func getTimeToMaintenance(time: Date) -> Single<MinerRewardInput> {
        return GetTimeToMaintenance(time: time).toCoreRequest(api.core)
    }
}
