import Foundation
import RxSwift

extension Error {
    fileprivate func asDCoreSecurityException() -> Single<Data> {
        if case .underlying(let error) = asDCoreException(), (error as NSError).code == -999 {
            return Single.error(DCoreException.network(.security("Server trust validation failed")))
        }
        return Single.error(asDCoreException())
    }
}

extension OperationQueue {
    fileprivate convenience init(qos: QualityOfService = .default, queue: DispatchQueue? = nil) {
        self.init()

        maxConcurrentOperationCount = OperationQueue.defaultMaxConcurrentOperationCount
        qualityOfService = qos
        underlyingQueue = queue
        name = DCore.namespace
    }
}

final class RestService: CoreRequestConvertible, Lifecycle {

    private let url: URL
    private let session: URLSession
    private let queue = DispatchQueue(label: DCore.namespace, qos: .default)
    private let delegate: ServerTrustDelegate  // swiftlint:disable:this weak_delegate
    private(set) var validator: ServerTrustValidation?
    private let timeout: TimeInterval
    
    init(_ url: URL,
         session: URLSession? = nil,
         delegate: ServerTrustDelegate? = nil,
         timeout: TimeInterval = DCore.Constant.timeout) {
        if let session = session, !session.delegate.isNil() {
            precondition(session.delegate is ServerTrustDelegate, "URLSession delegate does not inherit ServerTrustDelegate")
        }
        self.url = url
        self.delegate = delegate.or(ServerTrustDelegate())
        self.timeout = timeout
        self.session = session.or(URLSession(configuration: .default,
                                             delegate: self.delegate,
                                             delegateQueue: OperationQueue(queue: queue)))
        self.delegate.provider = self
    }
    
    deinit { dispose() }
        
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return Single.deferred { [unowned self] in
            return self.session.rx
                .asData(request: req.asRest(self.url, timeout: self.timeout), queue: self.queue)
                .catchError { $0.asDCoreSecurityException() }
                .map { res in
                    do { return try res.parse(response: req) } catch let error {
                        throw error.asDCoreException()
                    }
                }
            }
    }
    
    func dispose() { session.invalidateAndCancel() }
}

extension RestService: SecurityConfigurable {
    func secured(by validator: ServerTrustValidation?) {
        self.validator = validator
    }
}
extension RestService: SecurityProvider {}
