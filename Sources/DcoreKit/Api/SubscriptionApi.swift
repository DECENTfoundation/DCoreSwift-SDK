import Foundation
import RxSwift

public final class SubscriptionApi: BaseApi {

    public func cancelAllSubscriptions() -> Completable {
        return CancelAllSubscriptions().asCoreRequest(api.core).asCompletable()
    }

    public func setBlockAppliedCallback() -> Single<String> {
        return SetBlockAppliedCallback().asCoreRequest(api.core)
    }
    
    public func setContentUpdateCallback(uri: String) -> Completable {
        return SetContentUpdateCallback(uri: uri).asCoreRequest(api.core).asCompletable()
    }

    public func setPendingTransactionCallback() -> Completable {
        return SetPendingTransactionCallback().asCoreRequest(api.core).asCompletable()
    }
    
    public func setSubscribeCallback(clearFilter: Bool) -> Completable {
        return SetSubscribeCallback(clearFilter: clearFilter).asCoreRequest(api.core).asCompletable()
    }
}
