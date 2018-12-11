import Foundation
import BigInt

public struct PubKey {
    public var key: BigInt = 0
    
    public init(key: String) {
        self.key = BigInt(key)!
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
