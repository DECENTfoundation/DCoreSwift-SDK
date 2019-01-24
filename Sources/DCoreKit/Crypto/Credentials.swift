import Foundation

public struct Credentials {
    
    public let accountId: ChainObject
    public let keyPair: ECKeyPair
    
    public init(_ accountId: ChainObject, encryptedWif wif: String, passphrase: String) throws {
        let wif = try CryptoUtils.decrypt(using: passphrase, encryptedInput: wif)
        try self.init(accountId, wif: wif.to(type: String.self))
    }
    
    public init(_ accountId: ChainObject, wif: String) throws {
        self.init(accountId, keyPair: try ECKeyPair(fromWif: wif))
    }
    
    public init(_ accountId: ChainObject, keyPair: ECKeyPair) {
        self.accountId = accountId
        self.keyPair = keyPair
    }
}

extension Credentials: Equatable {}
