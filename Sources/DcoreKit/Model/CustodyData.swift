import Foundation


public struct CustodyData: Codable {
    
    public let n: Int
    public let uSeed: [UInt16] // Fixed size 16
    public let pubKey: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case
        n,
        uSeed = "u_seed",
        pubKey
    }
}

extension CustodyData: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not Implemented")
    }
}

/*
 override val bytes: ByteArray
 get() = Bytes.concat(
 n.bytes(),
 ByteArray(16, { 0 }),
 ByteArray(33, { 0 })
 )
 */
