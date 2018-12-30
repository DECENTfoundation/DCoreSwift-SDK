import Foundation

public struct BlockHeader: Codable {
    
    public let previous: String
    public let timestamp: Date
    public let miner: ChainObject
    public let transactionMerkleRoot: String
    
    private enum CodingKeys: String, CodingKey {
        case
        previous,
        timestamp,
        miner,
        transactionMerkleRoot = "transaction_merkle_root"
    }
}
