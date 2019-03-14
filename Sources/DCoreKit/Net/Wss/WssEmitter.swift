import Foundation
import Starscream
import RxSwift

extension Error {
    fileprivate func asDCoreSecurityException() -> DCoreException {
        if case .underlying(let error) = asDCoreException(), (error as? WSError)?.type == .invalidSSLError {
            return DCoreException.network(.security("Server trust validation failed"))
        }
        return asDCoreException()
    }
}

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
    private weak var security: SecurityProvider?

    init(_ url: URL, security: SecurityProvider?, observer: AnyObserver<SocketEvent>) {
        
        let wss = WebSocket(url: url, writeQueueQOS: .default)
        wss.onHttpResponseHeaders = { headers in
            DCore.Logger.debug(network: "WebSocket headers %{private}s", args: { "\(headers)" })
        }
        wss.onConnect = { [weak wss] in
            DCore.Logger.debug(network: "WebSocket connected: %{public}s", args: { String(describing: wss?.isConnected) })
            observer.onNext(OnOpenEvent(value: wss))
        }
        wss.onText = { observer.onNext(OnMessageEvent(value: $0)) }
        wss.onDisconnect = { error in
            if let error = error {
                DCore.Logger.error(network: "WebSocket disconnected with error: %{public}s", args: {
                    error.asDCoreException().description
                })
                observer.onError(error.asDCoreSecurityException())
            } else {
                DCore.Logger.debug(network: "WebSocket disconnected")
                observer.onCompleted()
            }
        }
        
        self.security = security
        self.source = wss
        self.source.security = self
    }
    
    @discardableResult
    func connect() -> WssEmitter {
        source.connect()
        return self
    }
    
    func disconnect() {
        source.disconnect()
    }
    
    func isValid(_ trust: SecTrust, domain: String?) -> Bool {
        if let validator = security?.validator, let host = domain {
            do {
                try validator.validate(trust: trust, for: host)
                return true
            } catch let error {
                DCore.Logger.error(network: "Server trust for wss failed with error: %{public}s", args: {
                    error.asDCoreException().description
                })
                return false
            }
        }
        return true
    }
}
