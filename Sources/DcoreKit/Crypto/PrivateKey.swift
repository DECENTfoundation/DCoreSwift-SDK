import Foundation
import COpenSSL
import secp256k1

struct PrivateKey {
    
    let data: Data
    let compressed: Bool
    
    init(fromWif wif: String) throws {
        guard let decoded = Base58.decode(wif) else {
            throw CryptoError.invalidFormat
        }
        
        let checksumDropped = decoded.prefix(decoded.count - 4)
        guard checksumDropped.count == (1 + 32) || checksumDropped.count == (1 + 32 + 1) else {
            throw CryptoError.invalidFormat
        }
        
        let addressPrefix = checksumDropped[0]
        print("Prefix \(addressPrefix)")
        
        let h = CryptoUtils.sha256sha256(checksumDropped)
        let calculatedChecksum = h.prefix(4)
        let originalChecksum = decoded.suffix(4)
        
        guard calculatedChecksum == originalChecksum else {
            throw CryptoError.invalidChecksum
        }
        
        self.init(data: checksumDropped.dropFirst().prefix(32), compressed: (checksumDropped.count == (1 + 32 + 1)))
    }
    
    init(data: Data, compressed: Bool = true) {
        self.data = data
        self.compressed = compressed
    }
    
    
    func toWif() -> String {
        var payload = data
        if compressed {
            // Add extra byte 0x01 in the end.
            payload += Int8(1)
        }
        
        let checksum = CryptoUtils.sha256sha256(payload).prefix(4)
        return Base58.encode(payload + checksum)
    }
    
    func toPublicKey() -> PublicKey {
        return PublicKey(fromPrivateKey: data, compressed: compressed)
    }
    
    func sign(_ message: Data) throws -> Data {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(ctx) }
        
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { signature.deallocate() }
        
        let status = message.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            data.withUnsafeBytes { secp256k1_ecdsa_sign(ctx, signature, ptr, $0, nil, nil) }
        }
        
        guard status == 1 else { throw CryptoError.signFailed }
        
        let normalizedsig = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { normalizedsig.deallocate() }
        
        secp256k1_ecdsa_signature_normalize(ctx, normalizedsig, signature)
        
        var length: size_t = 128
        var der = Data(count: length)
        
        guard der.withUnsafeMutableBytes({ return secp256k1_ecdsa_signature_serialize_der(ctx, $0, &length, normalizedsig) }) == 1 else {
            throw CryptoError.noEnoughSpace
        }
        
        der.count = length
        return der
    }
}


extension PrivateKey: Equatable {
    static func == (lhs: PrivateKey, rhs: PrivateKey) -> Bool {
        return lhs.data == rhs.data
    }
}

