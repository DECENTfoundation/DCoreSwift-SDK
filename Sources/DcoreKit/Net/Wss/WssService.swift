import Foundation
import RxSwift
import RxCocoa
import Starscream

final class WssService: CoreRequestConvertible {
    
    private let disposableBag = DisposeBag()
    private let disposable = CompositeDisposable()
    private let timeout: TimeInterval
    private let events: ConnectableObservable<SocketEvent>
    
    private var socket: AsyncSubject<WebSocket>?
    private var emitId: UInt64 = 0
    
    var connected: Bool {
        return disposable.count != 0
    }
    
    required init(_ url: URL, timeout: TimeInterval = 30) {
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
        return request(using: req, callId: self.increment()).asSingle()
    }
    
    func request<Output>(usingStream req: BaseRequest<Output>) -> Observable<Output> where Output: Codable {
        return request(using: req, callId: self.increment())
    }
    
    private func request<Output>(using req: BaseRequest<Output>, callId: UInt64) -> Observable<Output> where Output: Codable {
        return Observable.merge([
            events, Single
                .deferred({ [unowned self] in self.connectedSocket() })
                .do(onSuccess: { $0.write(string: try req.asWss(id: callId)) })
                .asObservableMapTo(OnEvent.empty)
        ])
        .ofType(OnMessageEvent.self)
        .map({ event in
            return try event.value.asData().asJsonDecoded(to: req) { try WssResultValidator(req, data:$0) }
        })
        .timeout(self.timeout, scheduler: SerialDispatchQueueScheduler(qos: .default))
        .do(onError: { [unowned self] error in
            if case RxError.timeout = error { self.clearConnection() }
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
                guard let value = event.value, let socket = self.socket else { fatalError("WebSocket was deallocated") }
                socket.applySingle(value)
            }).asObservable().catchErrorJustComplete().ignoreElements().subscribe()
        ])
        disposable.add(events.connect())
    }
    
    private func connectedSocket() -> Single<WebSocket> {
        if (socket == nil) {
            socket = AsyncSubject()
            
            connect()
        }
        return socket!.asSingle()
    }
    
    private func clearConnection() {
        socket = nil
        disposable.dispose()
        emitId = 0
    }
}
