import Foundation
import Starscream

enum WssEvent {
    
    case
    onSocket(WebSocket),
    onText(String),
    onData(Data)
    
    var isText: Bool {
        guard case .onText(_) = self else { return false }
        return true
    }
    
    func emit(_ value: String) throws {
        guard case .onSocket(let wss) = self else { fatalError() }
        wss.write(string: value)
    }
    
    func close() throws {
        guard case .onSocket(let wss) = self else { fatalError() }
        wss.disconnect(closeCode: 1000)
    }
}
