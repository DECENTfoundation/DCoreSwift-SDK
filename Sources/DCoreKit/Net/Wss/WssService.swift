import Foundation
import RxSwift
import Starscream

final class WssService: CoreRequestConvertible, Lifecycle {
    
    private let queue = SerialDispatchQueueScheduler(qos: .default)
    private let disposableBag = DisposeBag()
    
    private let timeout: TimeInterval
    
    private(set) var validator: ServerTrustValidation?
    private var disposable: CompositeDisposable?
    private var events: ConnectableObservable<SocketEvent>?
    private var socket: AsyncSubject<WebSocket>?
    
    private var emitId: UInt64 = 0
    
    var connected: Bool {
        return disposable?.count != 0 // swiftlint:disable:this empty_count
    }
    
    init(_ url: URL, timeout: TimeInterval) {
        self.timeout = timeout
        self.events = Observable.create { [weak self] observer in
            let wss: WssEmitter = WssEmitter(url, security: self, observer: observer).connect()
            return Disposables.create(with: wss.disconnect)
        }.publish()
    }
    
    func disconnect() {
        disposable?.add(
            connectedSocket().subscribe(onSuccess: { $0.disconnect() })
        )
    }
    
    func dispose() {
        socket = nil
        disposable?.dispose()
        disposable = nil
        emitId = 0
    }
    
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return self.request(usingStream: req).firstOrError().catchError {
            if case RxError.noElements = $0 { return Single.error(DCoreException.network(.closed)) } else {
                return Single.error($0.asDCoreException())
            }
        }
    }
    
    func request<Output>(usingStream req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
        return request(req.apply(id: self.increment()))
    }
    
    private func request<Output>(_ req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
        return Observable.deferred { [unowned self] in
            guard let events = self.events else {
                return Observable<Output>.error(DCoreException.unexpected("Websocket request failed"))
            }
            return Observable.merge([
                events, Single.deferred({ self.connectedSocket() })
                    .do(onSuccess: { $0.write(string: try req.asWss()) })
                    .asObservableMapTo(OnEvent.empty)
                ])
                .observeOn(self.queue)
                .ofType(OnMessageEvent.self)
                .filterMap({ res -> FilterMap<ResponseResult<Output>> in
                    let (valid, result) = res.value.asEncoded().parse(validResponse: req)
                    guard valid else { return .ignore }
                    
                    return .map(result)
                })
                .map({ result in
                    switch result {
                    case .success(let value): return value
                    case .failure(let error): throw error
                    }
                })
                .timeout(.seconds(Int(self.timeout)), scheduler: ConcurrentDispatchQueueScheduler(qos: .default))
                .do(onError: { [weak self] error in
                    if case RxError.timeout = error { self?.dispose() }
                })
        }
    }
   
    private func increment() -> UInt64 {
        self.emitId += 1
        return self.emitId
    }
    
    private func connect() {
        guard let events = events else { return }
        if !disposable.isNil() { dispose() }
        
        disposable = CompositeDisposable(disposables: [
            events.catchErrorJustComplete().do(onCompleted: { [weak self] in
                self?.dispose()
            }).subscribe(),
            events.ofType(OnOpenEvent.self).firstOrError().do(onSuccess: { [weak self] event in
                if let value = event.value, let socket = self?.socket { socket.applySingle(value) }
            }).catchErrorJustComplete().subscribe()
        ])
        disposable?.disposed(by: disposableBag)
        disposable?.add(events.connect())
    }
    
    private func connectedSocket() -> Single<WebSocket> {
        if let socket = socket { return socket.firstOrError() }
        socket = AsyncSubject()
        connect()
        
        return connectedSocket()
    }
}

extension WssService: SecurityConfigurable {
    func secured(by validator: ServerTrustValidation?) {
        self.validator = validator
    }
}
extension WssService: SecurityProvider {}
