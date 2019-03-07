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

struct WssEmitter: SSLTrustValidator {

    private let source: WebSocket
    private let security: SecurityProvider

    init(_ url: URL, security: SecurityProvider, observer: AnyObserver<SocketEvent>) {
        
        let wss = WebSocket(url: url, writeQueueQOS: .default)
        wss.onConnect = { [weak wss] in
            DCore.Logger.debug(network: "WebSocket connect")
            observer.onNext(OnOpenEvent(value: wss))
        }
        wss.onText = { observer.onNext(OnMessageEvent(value: $0)) }
        wss.onDisconnect = { error in
            
            if let error = error {
                DCore.Logger.error(network: "WebSocket disconnected with error: %{public}s", args: {
                    error.asDCoreException().description
                })
                observer.onError(error.asDCoreException())
            } else {
                DCore.Logger.debug(network: "WebSocket disconnected")
                observer.onCompleted()
            }
        }
        
        self.security = security
        self.source = wss
        self.source.security = self
    }
    
    func connect() { source.connect() }
    func disconnect() { source.disconnect() }
    
    func isValid(_ trust: SecTrust, domain: String?) -> Bool {
        if let validator = security.validator, let host = domain {
            do {
                try validator.validate(trust: trust, for: host)
                return true
            } catch let error {
                DCore.Logger.error(network: "Server trust failed with error %{public}s", args: {
                    error.asDCoreException().description
                })
                return false
            }
        }
        return true
    }
}
