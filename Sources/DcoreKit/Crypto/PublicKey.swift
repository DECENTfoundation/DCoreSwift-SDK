import Foundation
import COpenSSL
import secp256k1

struct PublicKey {

    let data: Data
    
    init(fromPrivateKey privateKey: Data, compressed: Bool) {
        self.init(data: PublicKey.compute(fromPrivateKey: privateKey, compression: compressed))
    }
    
    init(data: Data) {
        self.data = data
    }
    
    func verify(signature: Data, message: Data) throws -> Bool {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))!
        defer { secp256k1_context_destroy(ctx) }
        
        let signaturePointer = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { signaturePointer.deallocate() }
        
        guard signature.withUnsafeBytes({ secp256k1_ecdsa_signature_parse_der(ctx, signaturePointer, $0, signature.count) }) == 1 else {
            throw CryptoError.parseFailed
        }
        
        let pubkeyPointer = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        defer { pubkeyPointer.deallocate() }
        
        guard data.withUnsafeBytes({ secp256k1_ec_pubkey_parse(ctx, pubkeyPointer, $0, data.count) }) == 1 else {
            throw CryptoError.parseFailed
        }
        
        guard message.withUnsafeBytes ({ secp256k1_ecdsa_verify(ctx, signaturePointer, $0, pubkeyPointer) }) == 1 else {
            return false
        }
        
        return true
    }
    
    private static func compute(fromPrivateKey privateKey: Data, compression: Bool) -> Data {
        let ctx = BN_CTX_new()
        defer {
            BN_CTX_free(ctx)
        }
        
        let key = EC_KEY_new_by_curve_name(NID_secp256k1)
        defer {
            EC_KEY_free(key)
        }
        
        let group = EC_KEY_get0_group(key)
        let prv = BN_new()
        defer {
            BN_free(prv)
        }
        
        privateKey.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            BN_bin2bn(ptr, Int32(privateKey.count), prv)
            return
        }
        
        let pub = EC_POINT_new(group)
        defer {
            EC_POINT_free(pub)
        }
        
        EC_POINT_mul(group, pub, prv, nil, nil, ctx)
        EC_KEY_set_private_key(key, prv)
        EC_KEY_set_public_key(key, pub)
        
        if compression {
            EC_KEY_set_conv_form(key, POINT_CONVERSION_COMPRESSED)
            var ptr: UnsafeMutablePointer<UInt8>? = nil
            let length = i2o_ECPublicKey(key, &ptr)
            return Data(bytes: ptr!, count: Int(length))
        } else {
            var result = [UInt8](repeating: 0, count: 65)
            let n = BN_new()
            defer {
                BN_free(n)
            }
            EC_POINT_point2bn(group, pub, POINT_CONVERSION_UNCOMPRESSED, n, ctx)
            BN_bn2bin(n, &result)
            return Data(result)
        }
    }
}

extension PublicKey: Equatable {
    static func == (lhs: PublicKey, rhs: PublicKey) -> Bool {
        return lhs.data == rhs.data
    }
}
