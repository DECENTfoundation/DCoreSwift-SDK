import Foundation
import RxSwift

public final class SubscriptionApi: BaseApi {

    public func cancelAllSubscriptions() -> Completable {
        return CancelAllSubscriptions().base.toResponse(api.core).asCompletable()
    }

    public func setBlockAppliedCallback() -> Single<String> {
        return SetBlockAppliedCallback().base.toResponse(api.core)
    }
    
    public func setContentUpdateCallback(uri: String) -> Completable {
        return SetContentUpdateCallback(uri).base.toResponse(api.core).asCompletable()
    }

    public func setPendingTransactionCallback() -> Completable {
        return SetPendingTransactionCallback().base.toResponse(api.core).asCompletable()
    }
    
    public func setSubscribeCallback(clearFilter: Bool) -> Completable {
        return SetSubscribeCallback(clearFilter).base.toResponse(api.core).asCompletable()
    }
}
