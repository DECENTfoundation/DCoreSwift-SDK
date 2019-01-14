import Foundation

public struct Credentials {
    
    public let accountId: ChainObject
    public let keyPair: ECKeyPair
    
    public init(accountId id: ChainObject, wif: String) throws {
        self.init(accountId: id, keyPair: try ECKeyPair(fromWif: wif))
    }
    
    public init(accountId id: ChainObject, keyPair: ECKeyPair) {
        self.accountId = id
        self.keyPair = keyPair
    }
}

extension Credentials: Equatable {}
