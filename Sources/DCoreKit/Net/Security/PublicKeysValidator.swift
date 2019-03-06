import Foundation

private extension SecTrust {
    var publicKeys: Set<SecKey> {
        return (0..<SecTrustGetCertificateCount(self)).compactMap {
            SecTrustGetCertificateAtIndex(self, $0)
        }.publicKeys
    }
}

private extension SecKey {
    static func create(from value: String) throws -> SecKey {
        let options = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: NSNumber(value: 512),
            kSecReturnPersistentRef: true as NSObject
        ]
        
        guard let data = Data(base64Encoded: value),
            let key = SecKeyCreateWithData(data as CFData, options as CFDictionary, nil) else {
            
                throw DCoreException.network(.security("Could not parse public key \(value)"))
        }
        return key
    }
}

private extension SecCertificate {
    var publicKey: SecKey? {
        var trust: SecTrust?
        
        let policy = SecPolicyCreateBasicX509()
        let result = SecTrustCreateWithCertificates(self, policy, &trust)
        
        guard let created = trust, result == errSecSuccess else { return nil }
        
        return SecTrustCopyPublicKey(created)
    }
}

private extension Array where Element == SecCertificate {
    var publicKeys: Set<SecKey> {
        return Set(compactMap { $0.publicKey })
    }
}

public struct PublicKeysValidator: ServerTrustValidation {
    private let keys: [Pair<String, SecKey>]
    
    public init(host: String, pinnedKey key: String) throws {
        self.init(key: Pair(host, try .create(from: key)))
    }
    
    public init(key: Pair<String, SecKey>) {
        self.init(keys: [key])
    }
    
    public init(keys: [Pair<String, SecKey>]) {
        precondition(keys.isEmpty, "Public keys validator does not contain keys")
        self.keys = keys
    }
    
    public func configured(trust: SecTrust, for host: String) throws {
        let result = keys.filter { $0.first == host || $0.first.contains(host) || host.contains($0.first) }
        guard !Set(result.map { $0.second }).isDisjoint(with: trust.publicKeys) else {
            throw DCoreException.network(.security("Public key pinning failed"))
        }
    }
}
