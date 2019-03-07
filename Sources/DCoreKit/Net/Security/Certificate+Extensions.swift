import Foundation

extension SecTrust {
    var certificates: [SecCertificate] {
        return (0..<SecTrustGetCertificateCount(self)).compactMap { SecTrustGetCertificateAtIndex(self, $0) }
    }
    
    var publicKeys: Set<SecKey> {
        return Set(certificates.compactMap { $0.publicKey })
    }
    
    var certificatePins: Set<String> {
        return Set(certificates.map { CryptoUtils.hash256($0.asData()).base64EncodedString() })
    }
    
    var publicKeyPins: Set<String> {
        return Set(certificates.map { CryptoUtils.hash256($0.publicKey.asData()).base64EncodedString() })
    }
}

extension SecCertificate {
    var publicKey: SecKey? {
        if #available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *) {
            return SecCertificateCopyKey(self)
        }
        if #available(iOS 10.3, *) {
            #if os(iOS)
            return SecCertificateCopyPublicKey(self)
            #endif
        }
        if #available(OSX 10.3, *) {
            #if os(OSX)
            var key: SecKey?
            SecCertificateCopyPublicKey(self, &key)
            return key
            #endif
        }
        return nil
    }
}

extension SecCertificate: DataConvertible {}

extension DataConvertible where Self: SecCertificate {
    public func asData() -> Data {
        return SecCertificateCopyData(self) as NSData as Data
    }
}

extension SecKey: DataConvertible {}

extension DataConvertible where Self: SecKey {
    public func asData() -> Data {
        guard let data = SecKeyCopyExternalRepresentation(self, nil) else { return Data.empty }
        return (data as NSData as Data)
    }
}

extension Array where Element == SecCertificate {
    var publicKeys: Set<SecKey> {
        return Set(compactMap { $0.publicKey })
    }
}
