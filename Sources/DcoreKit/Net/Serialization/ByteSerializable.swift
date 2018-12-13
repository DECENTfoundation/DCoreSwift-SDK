import Foundation

public protocol ByteSerializable {
    var bytes: [UInt8] { get }
}

extension ByteSerializable {
    public var bytes: [UInt8] {
        return [UInt8]()
    }
}
