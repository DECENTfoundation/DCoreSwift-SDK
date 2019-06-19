import Foundation
import CryptoSwift
import DCoreKit.COpenSSL
import DCoreKit.secp256k1
import BigInt

public struct CryptoUtils {
    
    static func hash224(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(SHA224_DIGEST_LENGTH))
        data.withUnsafeBytes { ptr  in
            SHA224(ptr.bindMemory(to: UInt8.self).baseAddress, ptr.count, &result)
            return
        }
        return Data(result)
    }
    
    static func hash256(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { ptr in
            SHA256(ptr.bindMemory(to: UInt8.self).baseAddress, ptr.count, &result)
            return
        }
        return Data(result)
    }
    
    static func hashTwice256(_ data: Data) -> Data {
        return hash256(hash256(data))
    }
    
    static func ripemd160(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(RIPEMD160_DIGEST_LENGTH))
        data.withUnsafeBytes { ptr in
            RIPEMD160(ptr.bindMemory(to: UInt8.self).baseAddress, ptr.count, &result)
            return
        }
        return Data(result)
    }
    
    static func hash512(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes { ptr in
            SHA512(ptr.bindMemory(to: UInt8.self).baseAddress, ptr.count, &result)
            return
        }
        return Data(result)
    }

    static func encrypt(_ keyiv: Data, checksumInput input: Data) throws -> Data {
        let checksumed = hash256(input).prefix(4) + input
        return try encrypt(keyiv, input: checksumed)
    }
    
    static func encrypt(_ keyiv: Data, input: Data) throws -> Data {
        return try encrypt(keyiv[0..<32], iv: keyiv[32..<(32+16)], input: input)
    }
    
    static func encrypt(_ key: Data, iv: Data, input: Data) throws -> Data {
        do {
            return Data(try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).encrypt(input.bytes))
        } catch let error {
            DCore.Logger.debug(crypto: "Failed to encrypt %{private}s", args: { "\(error.localizedDescription)" })
            throw DCoreException.crypto(.failEncrypt("Cannot encrypt \(input.toHex()) with key: \(key.toHex())"))
        }
    }
    
    static func decrypt(_ keyiv: Data, checksumInput input: Data) throws -> Data {
        return try decrypt(keyiv[0..<32], iv: keyiv[32..<(32+16)], checksumInput: input)
    }
    
    static func decrypt(_ key: Data, iv: Data, checksumInput input: Data) throws -> Data {
        let data = try decrypt(key, iv: iv, input: input)
        let result = data[4..<data.endIndex]
        guard data.prefix(4) == hash256(result).prefix(4) else {
            throw DCoreException.crypto(.failDecrypt("Cannot decrypt \(input.toHex()), invalid checksum"))
        }
   
        return result
    }
    
    static func decrypt(_ passphrase: String, input: String) throws -> Data {
        let keyiv = hash512(passphrase.data(using: .utf8) ?? Data.empty)
        let unhexed = input.unhex() ?? Data.empty
        
        return try decrypt(keyiv, input: unhexed)
    }
    
    static func decrypt(_ keyiv: Data, input: Data) throws -> Data {
        return try decrypt(keyiv[0..<32], iv: keyiv[32..<(32+16)], input: input)
    }
    
    static func decrypt(_ key: Data, iv: Data, input: Data) throws -> Data {
        do {
            return Data(try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).decrypt(input.bytes))
        } catch let error {
            DCore.Logger.debug(crypto: "Failed to decrypt %{private}s", args: { "\(error.localizedDescription)" })
            throw DCoreException.crypto(.failDecrypt("Cannot decrypt \(input.toHex()) with key: \(key.toHex())"))
        }
    }
    
    static func secureRandom(_ count: Int = 32) -> Data {
        var bytes = Data(count: count)
        let result = bytes.withUnsafeMutableBytes { ptr in
            return ptr.baseAddress.map { SecRandomCopyBytes(kSecRandomDefault, count, $0) }.or(1)
        }
        
        precondition(result == 0, "Cannot generate secure random bytes")
        return bytes
    }

    public static func generateNonce() -> BigInt {
        let hash = hash224(ECKeyPair().privateKey.data)
        let data = Data(hash.prefix(1) + (withUnsafeBytes(of: Date().timeIntervalSince1970) { Data($0) }).prefix(7))
        return BigInt(sign: BigInt.Sign.plus, magnitude: BigUInt(data))
    }
    
}
