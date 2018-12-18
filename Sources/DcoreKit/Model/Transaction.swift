import Foundation

public struct Transaction: Codable {
    
    private var blockData: BlockData? = nil
    private var chainId: String? = nil
    
    public let operations: [BaseOperation]
    public var signatures: [String]?
    public let expiration: Date
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public var extensions: AnyValue?
    
    public init(blockData: BlockData, operations: [BaseOperation], chainId: String, signatures: [String]? = nil) {
        self.blockData = blockData
        self.chainId = chainId
        self.operations = operations
        self.expiration = Date(timeIntervalSince1970: TimeInterval(blockData.expiration))
        self.refBlockNum = blockData.refBlockNum
        self.refBlockPrefix = blockData.refBlockPrefix
    }
    
    private enum CodingKeys: String, CodingKey {
        case
        operations,
        signatures,
        expiration,
        refBlockNum = "ref_block_num",
        refBlockPrefix = "ref_block_prefix",
        extensions
    }
}

extension Transaction: DataSerializable {
    public var serialized: Data {
        fatalError("Not Implemeted")
    }
}
