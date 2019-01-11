import Foundation

struct GetRecentTransactionById: BaseRequestConvertible {
    
    typealias Output = ProcessedTransaction
    private(set) var base: BaseRequest<ProcessedTransaction>
    
    init(_ id: String) {
        
        precondition(id.unhex()?.count == 20, "Invalid transaction id")
        self.base = GetRecentTransactionById.toBase(.database, api: "get_recent_transaction_by_id", returnClass: ProcessedTransaction.self, params: [id])
    }
}
