import Foundation

public struct TransactionDetail: Codable {
    
    public let id: ChainObject
    public let from: ChainObject
    public let to: ChainObject
    public let type: Int
    public let amount: AssetAmount
    public var memo: Memo?
    public let fee: AssetAmount
    public let description: String
    public let timestamp: Date
    
    private enum CodingKeys: String, CodingKey {
        case
        id,
        from = "m_from_account",
        to = "m_to_account",
        type = "m_operation_type",
        amount = "m_transaction_amount",
        memo = "m_transaction_encrypted_memo",
        fee = "m_transaction_fee",
        description = "m_str_description",
        timestamp = "m_timestamp"
    }
}
