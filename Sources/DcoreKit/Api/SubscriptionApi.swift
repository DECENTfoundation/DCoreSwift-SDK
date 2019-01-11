import Foundation
import RxSwift

public final class SubscriptionApi: BaseApi {

    public func cancelAllSubscriptions() -> Completable {
        return CancelAllSubscriptions().base.asCoreRequest(api.core).asCompletable()
    }

    public func setBlockAppliedCallback() -> Single<String> {
        return SetBlockAppliedCallback().base.asCoreRequest(api.core)
    }
    
    public func setContentUpdateCallback(uri: String) -> Completable {
        return SetContentUpdateCallback(uri).base.asCoreRequest(api.core).asCompletable()
    }

    public func setPendingTransactionCallback() -> Completable {
        return SetPendingTransactionCallback().base.asCoreRequest(api.core).asCompletable()
    }
    
    public func setSubscribeCallback(clearFilter: Bool) -> Completable {
        return SetSubscribeCallback(clearFilter).base.asCoreRequest(api.core).asCompletable()
    }
}
