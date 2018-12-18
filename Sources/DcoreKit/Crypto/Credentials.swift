import Foundation

public struct Credentials {
    
    public let accountId: ChainObject
    public let keyPair: ECKeyPair
    
    init(accountId id: ChainObject, wif: String) throws {
        self.init(accountId: id, keyPair: try ECKeyPair(fromWif: wif))
    }
    
    init(accountId id: ChainObject, keyPair: ECKeyPair) {
        self.accountId = id
        self.keyPair = keyPair
    }
}

extension Credentials: Equatable {
    public static func == (lhs: Credentials, rhs: Credentials) -> Bool {
        return lhs.accountId == rhs.accountId && lhs.keyPair == rhs.keyPair
    }
}
