import Foundation
import RxSwift
import RxCocoa

extension Error {
    fileprivate func asDCoreSecurityException() -> Observable<Data> {
        if case .underlying(let error) = asDCoreException(), (error as NSError).code == -999 {
            return Observable.error(DCoreException.network(.security("Server trust validation failed")))
        }
        return Observable.error(asDCoreException())
    }
}

final class RestService: CoreRequestConvertible {

    private let url: URL
    private let session: URLSession
    private let delegate = RestSecurityDelegate() // swiftlint:disable:this weak_delegate
    private(set) var validator: ServerTrustValidation?
    
    init(_ url: URL, session: URLSession? = nil) {
        self.url = url
        self.session = session.or(URLSession(configuration: .default,
                                             delegate: self.delegate,
                                             delegateQueue: OperationQueue()))
        self.delegate.provider = self
    }
    
    deinit { session.invalidateAndCancel() }
        
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return Observable.deferred { [unowned self] in
            // TODO: DWI-81 URL session from member property should be used
            let sess = URLSession(configuration: .default,
                                  delegate: self.delegate,
                                  delegateQueue: OperationQueue())
            return sess.rx.data(request: req.asRest(self.url))
                .catchError { $0.asDCoreSecurityException() }
                .map { res in
                    do { return try res.parse(response: req) } catch let error {
                        throw error.asDCoreException()
                    }
                }
            }
            .asSingle()
    }
}

extension RestService: SecurityConfigurable {
    func secured(by validator: ServerTrustValidation?) {
        self.validator = validator
    }
}
extension RestService: SecurityProvider {}
