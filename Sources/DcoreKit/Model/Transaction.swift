import Foundation

public struct Transaction: Codable {
    
    private var blockData: BlockData? = nil
    private var chainId: String? = nil
    
    public var id: String {
        return CryptoUtils.hash256(serialized).prefix(20).toHex()
    }
    
    public let operations: [BaseOperation]
    public var signatures: [String]? = nil
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
    
    public mutating func with(signature keyPair: ECKeyPair) throws -> Transaction {
        let data = CryptoUtils.hash256(chainId!.unhex()! + self)
        signatures = [try keyPair.sign(data).toHex()]
        
        return self
    }
}

extension Transaction: DataSerializable {
    public var serialized: Data {
        var data = Data()
        data += blockData!
        data += operations
        data += Data(count: 1) // extensions
        return data
    }
}
