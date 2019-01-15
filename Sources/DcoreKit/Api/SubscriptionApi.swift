import Foundation
import RxSwift

public protocol SubscriptionApi: BaseApi {
    func cancelAllSubscriptions() -> Completable
    func setBlockAppliedCallback() -> Observable<String>
    func setContentUpdateCallback(uri: String) -> Observable<UnitValue>
    func setPendingTransactionCallback() -> Observable<UnitValue>
    func setSubscribeCallback(clearFilter: Bool) -> Observable<UnitValue>
}

extension SubscriptionApi {
    public func cancelAllSubscriptions() -> Completable {
        return CancelAllSubscriptions().base.toResponse(api.core).asCompletable()
    }
    
    public func setBlockAppliedCallback() -> Observable<String> {
        return SetBlockAppliedCallback().base.toStreamResponse(api.core)
    }
    
    public func setContentUpdateCallback(uri: String) -> Observable<UnitValue> {
        return SetContentUpdateCallback(uri).base.toStreamResponse(api.core)
    }
    
    public func setPendingTransactionCallback() -> Observable<UnitValue> {
        return SetPendingTransactionCallback().base.toStreamResponse(api.core)
    }
    
    public func setSubscribeCallback(clearFilter: Bool) -> Observable<UnitValue> {
        return SetSubscribeCallback(clearFilter).base.toStreamResponse(api.core)
    }
}

extension ApiProvider: SubscriptionApi {}
