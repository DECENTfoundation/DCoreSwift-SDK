import Foundation
import RxSwift

public protocol GeneralApi: BaseApi {
    /**
     Get info.
     
     - Returns: Info.
     */
    func getInfo() -> Single<String>
    
    /**
     Get properties associated with the chain.
     
     - Returns: `ChainProperties` with chain id and immutable chain parameters.
     */
    func getChainProperties() -> Single<ChainProperties>
    
    /**
     Get global properties. This object contains all of the properties,
     of the blockchain that are fixed, or that change only once per maintenance interval,
     such as the current list of miners, block interval, etc.
     
     - Returns: `GlobalProperties`.
     */
    func getGlobalProperties() -> Single<GlobalProperties>
    
    /**
     Get compile-time constants.
  
     - Returns: `Config` with configured constants.
     */
    func getConfiguration() -> Single<Config>
    
    /**
     Get the chain id.
     
     - Returns: Chain id identifying blockchain network.
     */
    func getChainId() -> Single<String>
    
    /**
     Retrieve the dynamic properties. The returned object contains information,
     that changes every block interval, such as the head block number, the next miner, etc.
     
     - Returns: `DynamicGlobalProps`.
     */
    func getDynamicGlobalProperties() -> Single<DynamicGlobalProps>
    
    /**
     Get remaining time to next maintenance interval from given time.
     
     - Parameter time: Reference time.
     
     - Returns: Remaining time to next maintenance interval,
     along with some additional data
     */
    func getTime(toMaintenance time: Date) -> Single<MinerRewardInput>
}

extension GeneralApi {
    public func getInfo() -> Single<String> {
        return Info().base.toResponse(api.core)
    }
    
    public func getChainProperties() -> Single<ChainProperties> {
        return GetChainProperties().base.toResponse(api.core)
    }
    
    public func getGlobalProperties() -> Single<GlobalProperties> {
        return GetGlobalProperties().base.toResponse(api.core)
    }
    
    public func getConfiguration() -> Single<Config> {
        return GetConfiguration().base.toResponse(api.core)
    }
    
    public func getChainId() -> Single<String> {
        return GetChainId().base.toResponse(api.core)
    }
    
    public func getDynamicGlobalProperties() -> Single<DynamicGlobalProps> {
        return GetDynamicGlobalProps().base.toResponse(api.core)
    }
    
    public func getTime(toMaintenance time: Date) -> Single<MinerRewardInput> {
        return GetTimeToMaintenance(time).base.toResponse(api.core)
    }
}

extension ApiProvider: GeneralApi {}
