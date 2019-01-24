import Foundation

public struct TransactionConfirmation<Input>: Codable where Input: Operation {
    
    public let id: String
    public let blockNum: UInt64
    public let trxNum: UInt64
    public let transaction: ProcessedTransaction<Input>
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        blockNum = "block_num",
        trxNum = "trx_num",
        transaction = "trx"
    }
}
