import Foundation
import RxSwift

public protocol GeneralApi: BaseApi {
    func info() -> Single<String>
    func getChainProperties() -> Single<ChainProperty>
    func getGlobalProperties() -> Single<GlobalProperty>
    func getConfig() -> Single<Config>
    func getChainId() -> Single<String>
    func getDynamicGlobalProperties() -> Single<DynamicGlobalProps>
    func getTimeToMaintenance(time: Date) -> Single<MinerRewardInput>
}

extension GeneralApi {
    public func info() -> Single<String> {
        return Info().base.toResponse(api.core)
    }
    
    public func getChainProperties() -> Single<ChainProperty> {
        return GetChainProperties().base.toResponse(api.core)
    }
    
    public func getGlobalProperties() -> Single<GlobalProperty> {
        return GetGlobalProperties().base.toResponse(api.core)
    }
    
    public func getConfig() -> Single<Config> {
        return GetConfig().base.toResponse(api.core)
    }
    
    public func getChainId() -> Single<String> {
        return GetChainId().base.toResponse(api.core)
    }
    
    public func getDynamicGlobalProperties() -> Single<DynamicGlobalProps> {
        return GetDynamicGlobalProps().base.toResponse(api.core)
    }
    
    public func getTimeToMaintenance(time: Date) -> Single<MinerRewardInput> {
        return GetTimeToMaintenance(time).base.toResponse(api.core)
    }
}

extension ApiProvider: GeneralApi {}
