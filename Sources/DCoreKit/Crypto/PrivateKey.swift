import Foundation
import COpenSSL
import secp256k1

struct PrivateKey {
    static let VERSION = 0x80
    
    let data: Data
    var version: Int = VERSION
    let compressed: Bool
    
    init(fromWif wif: String) throws {
        guard let decoded = Base58.decode(wif) else {
            throw DCoreException.crypto(.failDecode("Wif \(wif) has invalid format"))
        }
        
        let checksumDropped = decoded.prefix(decoded.count - 4)
        let calculatedChecksum = CryptoUtils.hashTwice256(checksumDropped).prefix(4)
        let originalChecksum = decoded.suffix(4)

        guard calculatedChecksum == originalChecksum else {
            throw DCoreException.crypto(.failDecode("Wif \(wif) has invalid checksum"))
        }
        
        let version = Int(checksumDropped.first!) & 0xFF
        precondition(version == PrivateKey.VERSION, "\(version) is not a valid private key version byte")
        
        // 1 + 32 + 1 = version + key + compressed
        // 1 + 32 = version + key
        
        guard checksumDropped.count == (1 + 32) || checksumDropped.count == (1 + 32 + 1) else {
            throw DCoreException.crypto(.failDecode("Wif \(wif) has invalid checksum count \(checksumDropped.count)"))
        }
        
        self.init(data: checksumDropped.dropFirst().prefix(32),
                  version: version,
                  compressed: (checksumDropped.count == (1 + 32 + 1)))
    }
    
    init(data: Data, version: Int = PrivateKey.VERSION, compressed: Bool = true) {
        self.data = data
        self.version = version
        self.compressed = compressed
    }
    
    func toWif() -> String {
        var payload = Data()
        payload += UInt8(version)
        payload += data
        
        if compressed {
            payload += Int8(1) // Add extra byte 0x01 in the end.
        }
        
        let checksum = CryptoUtils.hashTwice256(payload).prefix(4)
        return Base58.encode(payload + checksum)
    }
    
    func toPublicKey() -> PublicKey {
        return PublicKey(fromPrivateKey: data, compressed: compressed)
    }
    
    func sign(_ message: Data) throws -> (Int, Data) {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(ctx) }
        
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>.allocate(capacity: 1)
        defer { signature.deallocate() }
        
        let status = message.withUnsafeBytes { ptrMessage -> Int32 in
            guard let addressMessage = ptrMessage.bindMemory(to: UInt8.self).baseAddress else { return 1 }
            return data.withUnsafeBytes { ptrData -> Int32 in
                guard let addressData = ptrData.bindMemory(to: UInt8.self).baseAddress else { return 1 }
                return secp256k1_ecdsa_sign_recoverable(ctx, signature, addressMessage, addressData, nil, nil)
            }
        }
        
        guard status == 1 else { throw DCoreException.crypto(.failSigning) }
    
        var recovery: Int32 = 0
        var compact = Data(count: 64)
        guard (compact.withUnsafeMutableBytes { ptr -> Int32 in
            guard let address = ptr.bindMemory(to: UInt8.self).baseAddress else { return 1 }
            return secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, address, &recovery, signature)
        }) == 1 else {
            throw DCoreException.crypto(.notEnoughSpace)
        }
        
        return (Int(recovery), compact)
    }
}

extension PrivateKey: Equatable {
    static func == (lhs: PrivateKey, rhs: PrivateKey) -> Bool {
        return lhs.data == rhs.data
    }
}
