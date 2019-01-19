import Foundation

public struct ProcessedTransaction<Input>: Codable where Input: Operation {
    
    public let signatures: [String]
    public let extensions: AnyValue?
    public let operations: [Input]
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

extension ProcessedTransaction: DataEncodable {
    func asData() -> Data {
        var data = Data()
        data += blockData
        data += operations.asAnyOperations()
        data += Data.ofZero // extensions
        
        Logger.debug(crypto: "ProcessedTransaction binary: %{private}s", args: { "\(data.toHex()) (\(data))"})
        return data
    }
}
