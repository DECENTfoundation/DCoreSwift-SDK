import Foundation

public struct TransactionConfirmation: Codable {
    public let id: String
    public let blockNum: UInt64
    public let trxNum: UInt64
    public let transaction: ProcessedTransaction
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        blockNum = "block_num",
        trxNum = "trx_num",
        transaction = "trx"
    }
}
