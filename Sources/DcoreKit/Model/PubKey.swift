import Foundation
import BigInt

public struct PubKey: Codable {
    public var key: BigInt = 0
    
    public init(key: String) {
        self.key = BigInt(key)!
    }
    
    public init(from decoder: Decoder) throws {
        fatalError("Not implemented")
    }
    
    public func encode(to encoder: Encoder) throws {
        fatalError("Not implemented")
    }
}

extension PubKey: CustomStringConvertible {
    public var description: String {
        return "\(key)."
    }
}

extension PubKey: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not Implemented - Varint.writeUnsignedVarInt(keyString.toByteArray().size) + keyString.toByteArray()")
    }
}
