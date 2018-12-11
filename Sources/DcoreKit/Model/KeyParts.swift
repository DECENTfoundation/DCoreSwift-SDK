import Foundation

public struct KeyParts: Codable {
    
    public let keyC1: PubKey
    public let keyD1: PubKey
    
    private enum CodingKeys: String, CodingKey {
        case
        keyC1 = "C1",
        keyD1 = "D1"
    }
}

extension KeyParts: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not Implemented get() = Bytes.concat(keyC1.bytes, keyD1.bytes)")
    }
}
