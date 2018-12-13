import Foundation

public struct BlockData {
    
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public let expiration: UInt64
    
    init(props: DynamicGlobalProps, expiration: Int) {
        self.init(headBlockNumber: props.headBlockNumber,
                  headBlockId: props.headBlockId,
                  relativeExpiration: 0)
    }
    
    init(headBlockNumber: UInt64, headBlockId: String, relativeExpiration: UInt64) {

        self.refBlockNum = Int(headBlockNumber) & 0xFFFF
        self.refBlockPrefix = UInt64(String(headBlockId[safe: 8...16]!.chunked(2).reversed().joined(separator: "")), radix: 16)!
        self.expiration = relativeExpiration
    }
}

extension BlockData: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not Implemeted")
    }
}
