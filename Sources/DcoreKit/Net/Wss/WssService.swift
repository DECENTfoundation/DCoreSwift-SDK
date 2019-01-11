import Foundation
import RxSwift
import RxCocoa
import Starscream

final class WssService: CoreRequestSource {
    
    private let disposableBag = DisposeBag()
    private let disposable = CompositeDisposable()
    
    private let events: ConnectableObservable<SocketEvent>
    private let timeout: TimeInterval
    
    private var emitId: UInt64 = 0
    
    
    var connected: Bool {
        return disposable.count != 0
    }
    
    required init(_ url: URL, timeout: TimeInterval = 30) {
        disposable.disposed(by: disposableBag)
        
        self.timeout = timeout
        self.events = WssEmitter.connect(to: url)
    }
    
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return request(using: req, callId: self.increment(), callback: req.callback).asSingle()
    }
    
    func request<Output>(usingStream req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
        return request(using: req, callId: self.increment(), callback: req.callback)
    }
    
    private func request<Output>(using req: BaseRequest<Output>, callId: UInt64, callback: Bool = false) -> Observable<Output> where Output: Codable {
        return Observable.merge([
            events
        ])
        .ofType(OnMessageEvent.self)
        .map({ event in
            return try event.value.asData().asJsonDecoded(to: req) { try WssResultValidator($0) }
        })
        .timeout(self.timeout, scheduler: SerialDispatchQueueScheduler(qos: .default))
        .do(onError: { [unowned self] error in
            if case RxError.timeout = error { self.clearConnection() }
        })
    }
    
    /*
    private func emit<Output>(using req: BaseRequest<Output>, callId: UInt64, useCallback: Bool = false) -> Observable<SocketEvent> where Output: Codable {
        return Single.deferred({ [unowned self] in
            return self.emitter.asSingle().do(onSuccess: {
                $0.emit(try req.asWss(id: callId, useCallback: useCallback))
            })
        }).asObservableMapTo(OnEmitEvent())
    }*/
    
    private func increment() -> UInt64 {
        self.emitId += 1
        return self.emitId
    }
    
    private func connect() {
        
        /*
         
         return self.emitter.asSingle().do(onSuccess: { [unowned self] in
         $0.emit(try req.asWss(callback: self.increment()))
         }).asObservable().mapTo(OnEmitEvent())
        disposable.addAll(
            events.log("RxWebSocket")
                .onErrorResumeNext(Flowable.empty())
                .doOnComplete { clearConnection() }.subscribe(),
            events.ofType(OnOpen::class.java).firstOrError()
        .doOnSuccess { webSocketAsync!!.onNext(it.webSocket); webSocketAsync!!.onComplete() }
            .ignoreElement().onErrorComplete()
            .subscribe()
        )
        events.connect { it.addTo(disposable) }*/
    }
    
    func disconnect() {
        
    }
    
    private func clearConnection() {
        disposable.dispose()
        emitId = 0
    }
}

/*
.ofType(OnMessageText::class.java)
.map { parseIdAndElement(it.text) }
    .doOnNext { (id, obj) -> checkForError(callId, id, obj) }
    .filter { (id, _) -> id == callback ?: callId }
    .doOnNext { (_, obj) -> checkObjectNotFound(obj, this) }
    .map { (_, obj) -> parseResultElement(returnClass, obj) }
    .map { gson.fromJson<T>(it, returnClass) }
    .timeout(timeout, TimeUnit.SECONDS)
    .doOnError { if (it is TimeoutException) clearConnection() }
*/
