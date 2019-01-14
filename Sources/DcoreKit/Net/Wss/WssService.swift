import Foundation
import RxSwift
import RxCocoa
import Starscream

final class WssService: CoreRequestConvertible {
    
    private let disposableBag = DisposeBag()
    private let disposable = CompositeDisposable()
    private let events: ConnectableObservable<SocketEvent>
    private let timeout: TimeInterval
    
    private var socket: AsyncSubject<WebSocket>?
    private var emitId: UInt64 = 0
    
    var connected: Bool {
        return disposable.count != 0
    }
    
    required init(_ url: URL, timeout: TimeInterval) {
        disposable.disposed(by: disposableBag)
        
        self.timeout = timeout
        self.events = WssEmitter.connect(to: url)
    }
    
    func disconnect() {
        disposable.add(
            connectedSocket().subscribe(onSuccess: { $0.disconnect() })
        )
    }
    
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return Single.create(subscribe: { [unowned self] single in
            return self.request(usingStream: req)
                .single()
                .do(onNext: { single(.success($0)) }, onError: {
                    if case RxError.noElements = $0 { single(.error(ChainException.network(.closed))) } else {
                        single(.error($0.asChainException()))
                    }
                })
                .subscribe()
        })
    }
    
    func request<Output>(usingStream req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
        return request(req.apply(id: self.increment()))
    }
    
    private func request<Output>(_ req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
        return Observable.merge([
            events, Single
                .deferred({ [unowned self] in self.connectedSocket() })
                .do(onSuccess: { $0.write(string: try req.asWss()) })
                .asObservableMapTo(OnEvent.empty)
        ])
        .ofType(OnMessageEvent.self)
        .filterMap({ res -> FilterMap<ResponseResult<Output>> in
            
            let (valid, result) = res.value.asData().parse(validResponse: req)
            guard valid else { return .ignore }
            
            return .map(result)
        })
        .map({ result in
            switch result {
            case .success(let value): return value
            case .failure(let error): throw error
            }
        })
        .timeout(self.timeout, scheduler: SerialDispatchQueueScheduler(qos: .default))
        .do(onError: { [weak self] error in
            if case RxError.timeout = error { self?.clearConnection() }
        })
    }
   
    private func increment() -> UInt64 {
        self.emitId += 1
        return self.emitId
    }
    
    private func connect() {
        disposable.add(many: [
            events.catchErrorJustComplete().do(onCompleted: { [unowned self] in
                self.clearConnection()
            }).subscribe(),
            events.ofType(OnOpenEvent.self).single().do(onNext: { [unowned self] event in
                if let value = event.value, let socket = self.socket { socket.applySingle(value) }
            }).asObservable().catchErrorJustComplete().ignoreElements().subscribe()
        ])
        
        disposable.add(events.connect())
    }
    
    private func connectedSocket() -> Single<WebSocket> {
        
        if let socket = socket { return socket.asSingle() }
        
        socket = AsyncSubject()
        connect()
        
        Logger.debug(network: "WebSocket is connected")
        return connectedSocket()
    }
    
    private func clearConnection() {
        socket = nil
        disposable.dispose()
        emitId = 0
    }
}
