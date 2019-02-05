import Foundation
import Starscream
import RxSwift

protocol SocketEvent {}

struct OnOpenEvent: SocketEvent {
     private(set) weak var value: WebSocket?
}

struct OnMessageEvent: SocketEvent {
    private(set) var value: String
}

struct OnEvent: SocketEvent {
    static let empty: SocketEvent = OnEvent()
    
    private init() {}
}

struct WssEmitter {

    static func connect(to url: URL) -> ConnectableObservable<SocketEvent> {
        return Observable.create { observer -> Disposable in
            let emitter = WssEmitter(url, observer: observer)
            return Disposables.create(with: emitter.disconnect)
        }.publish()
    }
    
    private let source: WebSocket
    
    init(_ url: URL, observer: AnyObserver<SocketEvent>) {
        
        let source = WebSocket(url: url, writeQueueQOS: .userInitiated)
        source.onConnect = { observer.onNext(OnOpenEvent(value: source)) }
        source.onText = { observer.onNext(OnMessageEvent(value: $0)) }
        source.onDisconnect = { error in
            if let error = error {
                observer.onError(error.asDCoreException())
            } else {
                observer.onCompleted()
            }
        }
        
        self.source = source
        self.source.connect()
    }
    
    private func disconnect() { source.disconnect() }
}
