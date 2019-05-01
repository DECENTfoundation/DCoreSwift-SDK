import Foundation
import COpenSSL
import secp256k1

struct PublicKey {

    let data: Data
    
    init(fromPrivateKey privateKey: Data, compressed: Bool) {
        self.init(data: PublicKey.compute(fromPrivateKey: privateKey, compression: true)) // DCore has compressed
    }
    
    init(data: Data) {
        self.data = data
    }
        
    func multiply(_ privateKey: PrivateKey, compressed: Bool = true) throws -> Data {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_VERIFY))!
        defer { secp256k1_context_destroy(ctx) }
        
        let pubkeyPointer = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        defer { pubkeyPointer.deallocate() }
        
        guard (data.withUnsafeBytes { ptr -> Int32 in
            guard let address = ptr.bindMemory(to: UInt8.self).baseAddress else { return 1 }
            return secp256k1_ec_pubkey_parse(ctx, pubkeyPointer, address, ptr.count)
        }) == 1 else {
            throw DCoreException.crypto(.failMultiply)
        }
        
        guard (privateKey.data.withUnsafeBytes { ptr -> Int32 in
            guard let address = ptr.bindMemory(to: UInt8.self).baseAddress else { return 1 }
            return secp256k1_ec_pubkey_tweak_mul(ctx, pubkeyPointer, address)
        }) == 1 else {
            throw DCoreException.crypto(.failMultiply)
        }
        
        var count: size_t = 33
        var multiplied = Data(count: count)
        guard (multiplied.withUnsafeMutableBytes { ptr -> Int32 in
            guard let address = ptr.bindMemory(to: UInt8.self).baseAddress else { return 1 }
            return secp256k1_ec_pubkey_serialize(ctx, address, &count, pubkeyPointer, compressed ?
                UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
            )
        }) == 1 else {
            throw DCoreException.crypto(.notEnoughSpace)
        }
        return multiplied
    }
    
    private static func compute(fromPrivateKey privateKey: Data, compression: Bool = true) -> Data {
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
        
        privateKey.withUnsafeBytes { ptr in
            guard let address = ptr.bindMemory(to: UInt8.self).baseAddress else { return }
            BN_bin2bn(address, Int32(ptr.count), prv)
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
            var ptr: UnsafeMutablePointer<UInt8>?
            let length = i2o_ECPublicKey(key, &ptr)
            return Data(bytes: ptr!, count: Int(length))
        } else {
            var result = [UInt8](repeating: 0, count: 65)
            let val = BN_new()
            defer {
                BN_free(val)
            }
            EC_POINT_point2bn(group, pub, POINT_CONVERSION_UNCOMPRESSED, val, ctx)
            BN_bn2bin(val, &result)
            return Data(result)
        }
    }
}

extension PublicKey: Equatable {}
