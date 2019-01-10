import Foundation
import RxSwift
import Starscream

final class WssService: CoreRequestSource {
    
    private let disposableBag = DisposeBag()
    private let disposable = CompositeDisposable()
    
    private let events = PublishSubject<WssEvent>()
    private let emitter: WssEmitter
    private let timeout: TimeInterval
    
    private var emitId: UInt64 = 0
    
    var connected: Bool {
        return disposable.count != 0
    }
    
    required init(_ url: URL, timeout: TimeInterval = 10) {
        disposable.disposed(by: disposableBag)
        
        self.emitter = WssEmitter(url, emitter: events.asObserver())
        self.timeout = timeout
    }
    
    func request<Output>(using req: BaseRequest<Output>) -> Single<Output> where Output: Codable {
        return Observable
            .merge([events, Single.deferred({ [unowned self] in
                    return self.source().do(onSuccess: { [unowned self] in try $0.emit(try req.asWss(callback: self.increment())) })
                }).asObservable()
            ])
            .filter({ $0.isText })
            .map({ event in
                guard case .onText(let value) = event else { fatalError("") }
                return try value.asData().asJsonDecoded(to: req) { try WssResultValidator($0) }
            })
            .timeout(self.timeout, scheduler: SerialDispatchQueueScheduler(qos: .default))
            .do(onError: { [unowned self] error in
                if case RxError.timeout = error { self.clearConnection() }
            })
            .asSingle()
    }
    
    private func source() -> Single<WssEvent> {
        fatalError()
    }
    
    private func increment() -> UInt64 {
        self.emitId += 1
        return self.emitId
    }
    
    
    
    private func connect() {
        let _ = disposable.insert(events.do(onCompleted: { [unowned self] in
            self.clearConnection()
        }).subscribe())
        /*
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
    
    private func disconnect() {
        let _ = disposable.insert(
            source().subscribe(onSuccess: {
                try? $0.close()
            })
        )
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
