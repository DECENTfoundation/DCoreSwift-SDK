import Foundation

public struct Transaction: Codable {
    
    private var blockData: BlockData?
    private var chainId: String?
    
    public lazy var id: String = CryptoUtils.hash256(asData()).prefix(20).toHex()
    
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
    
    public func with(signature keyPair: ECKeyPair) throws -> Transaction {
        guard let chain = chainId?.unhex() else { throw ChainException.crypto(.failSigning) }
        
        var trx = self
        var signature: String = ""
        
        repeat {
            trx = trx.extend()
            let hash = CryptoUtils.hash256(chain + trx)
            signature = (try? keyPair.sign(hash).toHex()).or("")
        } while (signature.isEmpty)
        
        trx.signatures = [signature]
        return trx
    }
    
    private func extend() -> Transaction {
        var trx = self
        trx.blockData = blockData?.extend()
        return trx
    }
}

extension Transaction: DataEncodable {
    func asData() -> Data {
        var data = Data()
        data += blockData
        data += operations
        data += Data.ofZero // extensions
        
        Logger.debug(crypto: "Transaction binary: %{private}s", args: { "\(data.toHex()) (\(data))" })
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
