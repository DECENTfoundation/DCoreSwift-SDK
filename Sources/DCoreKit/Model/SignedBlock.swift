import Foundation

public struct SignedBlock: Codable {

    public let previous: String
    public let timestamp: Date
    public let miner: MinerObjectId
    public let transactionMerkleRoot: String
    public let minerSignature: String
    public let transactions: [ProcessedTransaction]
    public let extensions: AnyValue?
    
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
