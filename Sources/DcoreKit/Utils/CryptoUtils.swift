import Foundation
import COpenSSL
import secp256k1

struct CryptoUtils {
    
    static func sha1(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(SHA_DIGEST_LENGTH))
        data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            SHA1(ptr, data.count, &result)
            return
        }
        return Data(result)
    }
    
    static func sha256(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            SHA256(ptr, data.count, &result)
            return
        }
        return Data(result)
    }
    
    static func sha256sha256(_ data: Data) -> Data {
        return sha256(sha256(data))
    }
    
    static func ripemd160(_ data: Data) -> Data {
        var result = [UInt8](repeating: 0, count: Int(RIPEMD160_DIGEST_LENGTH))
        data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            RIPEMD160(ptr, data.count, &result)
            return
        }
        return Data(result)
    }

}
