import Foundation

public struct Credentials {
    
    static let null = Credentials(ObjectType.accountObject.genericId(), keyPair: ECKeyPair())
    
    public let accountId: AccountObjectId
    public let keyPair: ECKeyPair
    
    public init(_ accountId: AccountObjectId, encryptedWif wif: String, passphrase: String) throws {
        let wif = try CryptoUtils.decrypt(passphrase, input: wif)
        try self.init(accountId, wif: wif.to(type: String.self))
    }
    
    public init(_ accountId: AccountObjectId, wif: String) throws {
        self.init(accountId, keyPair: try ECKeyPair(fromWif: wif))
    }
    
    public init(_ accountId: AccountObjectId, keyPair: ECKeyPair) {
        self.accountId = accountId
        self.keyPair = keyPair
    }
}

extension Credentials: Equatable {}
