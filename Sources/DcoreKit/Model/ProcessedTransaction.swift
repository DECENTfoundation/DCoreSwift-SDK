import Foundation

public struct ProcessedTransaction: Codable {
    public let signatures: [String]
    public let extensions: AnyValue?
    public let operations: [BaseOperation]
    public let expiration: Date
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public let opResults: AnyValue?
    
    public var id: String {
        return CryptoUtils.sha256(serialized).prefix(20).toHex()
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        signatures,
        extensions,
        operations,
        expiration,
        refBlockNum = "ref_block_num",
        refBlockPrefix = "ref_block_prefix",
        opResults = "operation_results"
    }
}

extension ProcessedTransaction: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += BlockData(refBlockNum: refBlockNum, refBlockPrefix: refBlockPrefix, expiration: UInt64(expiration.timeIntervalSince1970))
        data += operations
        data += Data(count: 1) // extensions
        return data
    }
}
