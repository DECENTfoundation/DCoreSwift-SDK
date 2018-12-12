import Foundation

public struct ProcessedTransaction: Codable {
    
    public let signatures: [String]
    public let extensions: AnyValue?
    public let operations: [BaseOperation]
    public let expiration: Date
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public let opResults: AnyValue?
    
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
