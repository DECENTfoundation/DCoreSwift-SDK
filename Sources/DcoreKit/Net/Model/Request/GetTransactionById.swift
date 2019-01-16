import Foundation

struct GetTransactionById: BaseRequestConvertible {
    
    typealias Output = ProcessedTransaction
    private(set) var base: BaseRequest<ProcessedTransaction>
    
    init(_ id: String) {
        
        precondition(id.unhex()?.count == 20, "Invalid transaction id")
        self.base = GetTransactionById.toBase(
            .database, api: "get_transaction_by_id", returnType: ProcessedTransaction.self, params: [id]
        )
    }
}
