import Foundation

public struct Transaction {
    
    private var blockData: BlockData?
    private var chainId: String?
    
    public lazy var id: String = CryptoUtils.hash256(asData()).prefix(20).toHex()
    
    public let operations: [Operation]
    public var signatures: [String]?
    public private(set) var expiration: Date
    public let refBlockNum: Int
    public let refBlockPrefix: UInt64
    public var extensions: AnyValue?
    
    public init(_ blockData: BlockData, operations: [Operation], chainId: String, signatures: [String]? = nil) {
        self.blockData = blockData
        self.chainId = chainId
        self.operations = operations
        self.expiration = Transaction.expiration(from: blockData)
        self.refBlockNum = blockData.refBlockNum
        self.refBlockPrefix = blockData.refBlockPrefix
        self.extensions = .array([])
    }
    
    public func with(signature keyPair: ECKeyPair) throws -> Transaction {
        guard let chain = chainId?.unhex() else { throw DCoreException.crypto(.failSigning) }
        
        var trx = self
        var signature: String = ""
        repeat {
            trx = trx.extend()
            let hash = CryptoUtils.hash256(chain + trx.asData())
            signature = (try? keyPair.sign(hash).toHex()).or("")
        } while (signature.isEmpty)
        
        trx.signatures = [signature]
        return trx
    }
    
    private func extend() -> Transaction {
        var trx = self
        trx.blockData = blockData?.extend()
        if let blockData = trx.blockData {
            trx.expiration = Transaction.expiration(from: blockData)
        }
        return trx
    }

    private static func expiration(from blockData: BlockData) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(blockData.expiration))
    }
}

extension Transaction: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case
        operations,
        signatures,
        expiration,
        refBlockNum = "ref_block_num",
        refBlockPrefix = "ref_block_prefix",
        extensions
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        signatures =        try container.decodeIfPresent([String].self, forKey: .signatures)
        expiration =        try container.decode(Date.self, forKey: .expiration)
        refBlockNum =       try container.decode(Int.self, forKey: .refBlockNum)
        refBlockPrefix =    try container.decode(UInt64.self, forKey: .refBlockPrefix)
        extensions =        try container.decodeIfPresent(AnyValue.self, forKey: .extensions)
        
        operations = try container.decode([AnyOperation].self, forKey: .operations).asOperations()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(signatures, forKey: .signatures)
        try container.encode(expiration, forKey: .expiration)
        try container.encode(refBlockNum, forKey: .refBlockNum)
        try container.encode(refBlockPrefix, forKey: .refBlockPrefix)
        try container.encodeIfPresent(extensions, forKey: .extensions)
        
        try container.encode(operations.map { $0.asAnyOperation() }, forKey: .operations)
    }
}

extension Transaction: DataConvertible {
    public func asData() -> Data {
        var data = Data()
        data += blockData.asData()
        data += operations.map { $0.asAnyOperation() }.asData()
        data += Data.ofZero
        
        DCore.Logger.debug(crypto: "Transaction binary: %{private}s", args: {
            "\(data.toHex()) (\(data)) \(data.bytes)s"
        })
        return data
    }
}

fileprivate extension BlockData {
    fileprivate func extend() -> BlockData {
        var block = self
        block.expiration += 1
        
        return block
    }
}
