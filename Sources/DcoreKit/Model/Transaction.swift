import Foundation

public struct Transaction: Codable {
    
    private let blockData: BlockData
    private let chainId: String
    
    public let operations: [BaseOperation]
    public var signatures: [String]?
    public let expiration: Date
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public var extensions: [Any] = [Any]()
    
    public init(blockData: BlockData, operations: [BaseOperation], chainId: String, signatures: [String]? = nil) {
        self.blockData = blockData
        self.chainId = chainId
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

extension Transaction: ByteSerializable {
    public var bytes: [UInt8] {
        fatalError("Not Implemeted")
    }
}
