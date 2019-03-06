import Foundation

public struct BlockHeader: Codable, Equatable {
    
    public let previous: String
    public let timestamp: Date
    public let miner: ChainObject
    public let transactionMerkleRoot: String
    
    public var num: UInt64? = 0
    
    private enum CodingKeys: String, CodingKey {
        case
        num,
        previous,
        timestamp,
        miner,
        transactionMerkleRoot = "transaction_merkle_root"
    }
    
    func apply(num number: UInt64) -> BlockHeader {
        var block = self
        block.num = number
        
        return block
    }
}
