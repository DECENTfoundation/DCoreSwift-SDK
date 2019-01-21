import Foundation

public struct BlockData {
    
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public var expiration: UInt64
    
    init(props: DynamicGlobalProps, expiration: Int) {
        let exp = UInt64(props.time.addingTimeInterval(TimeInterval(expiration)).timeIntervalSince1970)
        self.init(headBlockNumber: props.headBlockNumber,
                  headBlockId: props.headBlockId,
                  relativeExpiration: exp
        )
    }
    
    init(headBlockNumber: UInt64, headBlockId: String, relativeExpiration: UInt64) {
        let prefix = String(headBlockId[safe: 8...16]!.chunked(2).reversed().joined(separator: ""))
        self.init(refBlockNum: Int(headBlockNumber) & 0xFFFF,
                  refBlockPrefix: UInt64(prefix, radix: 16)!,
                  expiration: relativeExpiration)
    }
    
    init(refBlockNum: Int, refBlockPrefix: UInt64, expiration: UInt64) {
        self.refBlockNum = refBlockNum
        self.refBlockPrefix = refBlockPrefix
        self.expiration = expiration
    }
}

extension BlockData: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        // Allocating a fixed length byte array, since we will always need
        // 2 bytes for the ref_block_num value
        // 4 bytes for the ref_block_prefix value
        // 4 bytes for the relative_expiration
        data += Data(bytes: Data(count: 2).indices.map({ UInt8(refBlockNum >> 8 * $0) }))
        data += Data(bytes: Data(count: 4).indices.map({ UInt8.with(value: refBlockPrefix >> 8 * UInt64($0)) }))
        data += Data(bytes: Data(count: 4).indices.map({ UInt8.with(value: expiration >> 8 * UInt64($0)) }))
        
        Logger.debug(crypto: "BlockData binary: %{private}s", args: { "\(data.toHex()) (\(data)) \(data.bytes)"})
        return data
    }
}
