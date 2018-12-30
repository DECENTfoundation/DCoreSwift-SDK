import Foundation
import RxSwift

public final class SubscriptionApi: BaseApi {

    public func cancelAllSubscriptions() -> Completable {
        return CancelAllSubscriptions().toRequest(core: api.core).asCompletable()
    }

    public func setBlockAppliedCallback() -> Single<String> {
        return SetBlockAppliedCallback().toRequest(core: api.core)
    }
    
    public func setContentUpdateCallback(uri: String) -> Completable {
        return SetContentUpdateCallback(uri: uri).toRequest(core: api.core).asCompletable()
    }

    public func setPendingTransactionCallback() -> Completable {
        return SetPendingTransactionCallback().toRequest(core: api.core).asCompletable()
    }
    
    public func setSubscribeCallback(clearFilter: Bool) -> Completable {
        return SetSubscribeCallback(clearFilter: clearFilter).toRequest(core: api.core).asCompletable()
    }
}
