import Foundation

public struct BlockData {
    
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public let expiration: UInt64
    
}

extension BlockData: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not Implemeted")
    }
}
