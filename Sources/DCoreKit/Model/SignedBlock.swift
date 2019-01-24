import Foundation

public struct SignedBlock<Input>: Codable where Input: Operation {

    public let previous: String
    public let timestamp: Date
    public let miner: ChainObject
    public let transactionMerkleRoot: String
    public let minerSignature: String
    public let transactions: [ProcessedTransaction<Input>]
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
