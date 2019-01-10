import Foundation
import Starscream
import RxSwift

final class WssEmitter {
    
    private let socket: WebSocket
    private let emitter: AnyObserver<WssEvent>
    
    var source: Single<WssEmitter> {
        fatalError()
    }
    
    init(_ url: URL, emitter: AnyObserver<WssEvent>) {
        self.emitter = emitter
        
        socket = WebSocket(url: url, writeQueueQOS: .userInitiated)

        socket.onConnect = { [unowned self] in self.emitter.onNext(.onSocket(self.socket)) }
        socket.onText = { [unowned self] in self.emitter.onNext(.onText($0)) }
        socket.onData = { [unowned self] in self.emitter.onNext(.onData($0)) }
        
        socket.onDisconnect = { [unowned self] (error: Error?) in
            if let error = error {
                self.emitter.onError(error.asChainException())
            } else {
                self.emitter.onCompleted()
            }
        }
    }

}

