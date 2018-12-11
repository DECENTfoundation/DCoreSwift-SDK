import Foundation

public struct SignedBlock: Codable {
    
    public let previous: String
    public let timestamp: Date
    public let miner: ChainObject
    public let transactionMerkleRoot: String
    public let minerSignature: String
    public let transactions: [ProcessedTransaction]
    public let extensions: [Any]
    
    private enum CodingKeys: String, CodingKey {
        case
        previous,
        timestamp,
        miner,
        transactionMerkleRoot = "transaction_merkle_root",
        minerSignature = "miner_signature",
        transactions,
        extensions
    }
}
