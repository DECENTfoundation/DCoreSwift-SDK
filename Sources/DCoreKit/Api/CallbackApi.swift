import Foundation
import RxSwift

public protocol CallbackApi: BaseApi {    
    /**
     Receive new block notifications. Cannot be cancelled.
     */
    func onBlockApplied() -> Observable<String>
    
    /**
     Receive notifications on content update. Cannot be cancelled.
     
     - Parameter url: Content url (URL or String).
     */
    func onContentUpdate(url: URLConvertible) -> Observable<Void>
    
    /**
     Receive notifications on pending transactions. Cannot be cancelled.
     */
    func onPendingTransaction() -> Observable<Void>
}

extension CallbackApi {
    public func onBlockApplied() -> Observable<String> {
        return SetBlockAppliedCallback().base.toStreamResponse(api.core)
    }
    
    public func onContentUpdate(url: URLConvertible) -> Observable<Void> {
        return Observable.deferred {
            guard let uri = url.asURL()?.absoluteString, Content.hasValid(uri: uri) else {
                return Observable.error(DCoreException.unexpected("Invalid content uri"))
            }
            return SetContentUpdateCallback(uri).base.toStreamResponse(self.api.core).mapVoid()
        }
    }
    
    public func onPendingTransaction() -> Observable<Void> {
        return SetPendingTransactionCallback().base.toStreamResponse(api.core).mapVoid()
    }
}

extension ApiProvider: CallbackApi {}
