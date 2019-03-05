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

    private let source: WebSocket
    
    init(_ url: URL, observer: AnyObserver<SocketEvent>) {
        
        let wss = WebSocket(url: url, writeQueueQOS: .default)
        wss.onConnect = { [weak wss] in
            DCore.Logger.debug(network: "WebSocket connect")
            observer.onNext(OnOpenEvent(value: wss))
        }
        wss.onText = { observer.onNext(OnMessageEvent(value: $0)) }
        wss.onDisconnect = { error in
            
            if let error = error {
                DCore.Logger.error(network: "WebSocket disconnected with error: %{public}s", args: {
                    error.localizedDescription
                })
                observer.onError(error.asDCoreException())
            } else {
                DCore.Logger.debug(network: "WebSocket disconnected")
                observer.onCompleted()
            }
        }
        
        source = wss
    }
    
    func connect() { source.connect() }
    func disconnect() { source.disconnect() }
}
