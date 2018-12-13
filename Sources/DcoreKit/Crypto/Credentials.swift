import Foundation

public struct Credentials {
    
    public let account: ChainObject
    public let keyPair: ECKeyPair
    
    init(account: ChainObject, encodedPrivateKey: String) {
        self.init(account: account, keyPair: ECKeyPair.from(base58: encodedPrivateKey))
    }
    
    init(account: ChainObject, keyPair: ECKeyPair) {
        self.account = account
        self.keyPair = keyPair
    }
}
