import Foundation
import CryptoSwift
import COpenSSL
import secp256k1
import BigInt

public struct CryptoUtils {
    
    static func hash224(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(SHA224_DIGEST_LENGTH))
        data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            SHA224(ptr, data.count, &result)
            return
        }
        return Data(result)
    }
    
    static func hash256(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            SHA256(ptr, data.count, &result)
            return
        }
        return Data(result)
    }
    
    static func hashTwice256(_ data: Data) -> Data {
        return hash256(hash256(data))
    }
    
    static func ripemd160(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(RIPEMD160_DIGEST_LENGTH))
        data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            RIPEMD160(ptr, data.count, &result)
            return
        }
        return Data(result)
    }
    
    static func hash512(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            SHA512(ptr, data.count, &result)
            return
        }
        return Data(result)
    }
    
    static func encrypt(_ key: Data, iv: Data, input: Data) throws -> Data {
        return Data(try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).encrypt(input.bytes))
    }
    
    static func decrypt(_ key: Data, iv: Data, input: Data) throws -> Data {
        return Data(try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).decrypt(input.bytes))
    }
    
    static func decrypt(using passphrase: String, encryptedInput input: String) throws -> Data {
        do {
            let keyiv = hash512(passphrase.data(using: .utf8) ?? Data(count: 0))
            let unhexed = input.unhex() ?? Data(count: 0)
            
            return try decrypt(keyiv[0..<32], iv: keyiv[32..<(32+16)], input: unhexed)
        } catch {
            throw  ChainException.crypto(.failDecrypt("Cannot decrypt \(input) with passphrase: \(passphrase)"))
        }
    }
    
    static func secureRandom(_ count: Int = 32) -> Data {
        var bytes = Data(count: count)
        let result = bytes.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, count, $0) }
        
        precondition(result == 0, "Cannot generate secure random bytes")

        return bytes
    }

    public static func generateNonce() -> BigInt {
        let hash = hash224(ECKeyPair().privateKey.data)
        let data = Data(hash.prefix(1) + (withUnsafeBytes(of: Date().timeIntervalSince1970) { Data($0) }).prefix(7))
        return BigInt(sign: BigInt.Sign.plus, magnitude: BigUInt(data))
    }
    
}
