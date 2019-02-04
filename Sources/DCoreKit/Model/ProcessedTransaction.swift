import Foundation

public struct ProcessedTransaction {
    
    public let signatures: [String]
    public let extensions: AnyValue?
    public let operations: [Operation]
    public let expiration: Date
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public let opResults: AnyValue?
    
    public lazy var id: String = CryptoUtils.hash256(asData()).prefix(20).toHex()
    
    fileprivate var blockData: BlockData {
        return BlockData(refBlockNum: refBlockNum,
                         refBlockPrefix: refBlockPrefix,
                         expiration: UInt64(expiration.timeIntervalSince1970))
    }
}

extension ProcessedTransaction: Codable {
    
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        signatures =        try container.decode([String].self, forKey: .signatures)
        extensions =        try container.decodeIfPresent(AnyValue.self, forKey: .extensions)
        expiration =        try container.decode(Date.self, forKey: .expiration)
        refBlockNum =       try container.decode(Int.self, forKey: .refBlockNum)
        refBlockPrefix =    try container.decode(UInt64.self, forKey: .refBlockPrefix)
        opResults =         try container.decodeIfPresent(AnyValue.self, forKey: .opResults)
        
        operations = try container.decode([AnyOperation].self, forKey: .operations).asOperations()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(signatures, forKey: .signatures)
        try container.encodeIfPresent(extensions, forKey: .extensions)
        try container.encode(expiration, forKey: .expiration)
        try container.encode(refBlockNum, forKey: .refBlockNum)
        try container.encode(refBlockPrefix, forKey: .refBlockPrefix)
        try container.encodeIfPresent(opResults, forKey: .opResults)
        
        try container.encode(operations.map { $0.asAnyOperation() }, forKey: .operations)
    }
}

extension ProcessedTransaction {
    public func asData() -> Data {
        var data = Data()
        data += blockData.asData()
        data += operations.map { $0.asAnyOperation() }.asData()
        data += Data.ofZero // extensions
        
        DCore.Logger.debug(crypto: "ProcessedTransaction binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)"
        })
        return data
    }
}
