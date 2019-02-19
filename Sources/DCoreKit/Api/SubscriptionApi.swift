import Foundation
import RxSwift

public protocol SubscriptionApi: BaseApi {
    func cancelAllSubscriptions() -> Completable
    func setBlockAppliedCallback() -> Observable<String>
    func setContentUpdateCallback(uri: String) -> Observable<Void>
    func setPendingTransactionCallback() -> Observable<Void>
    func setSubscribeCallback(clearFilter: Bool) -> Observable<Void>
}

extension SubscriptionApi {
    public func cancelAllSubscriptions() -> Completable {
        return CancelAllSubscriptions().base.toResponse(api.core).asCompletable()
    }
    
    public func setBlockAppliedCallback() -> Observable<String> {
        return SetBlockAppliedCallback().base.toStreamResponse(api.core)
    }
    
    public func setContentUpdateCallback(uri: String) -> Observable<Void> {
        return SetContentUpdateCallback(uri).base.toStreamResponse(api.core).map { _ in () }
    }
    
    public func setPendingTransactionCallback() -> Observable<Void> {
        return SetPendingTransactionCallback().base.toStreamResponse(api.core).map { _ in () }
    }
    
    public func setSubscribeCallback(clearFilter: Bool) -> Observable<Void> {
        return SetSubscribeCallback(clearFilter).base.toStreamResponse(api.core).map { _ in () }
    }
}

extension ApiProvider: SubscriptionApi {}
