import Foundation

struct GetRecentTransactionById<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = ProcessedTransaction<Input>
    private(set) var base: BaseRequest<ProcessedTransaction<Input>>
    
    init(_ id: String) {
        
        precondition(id.unhex()?.count == 20, "Invalid transaction id")
        self.base = GetRecentTransactionById.toBase(
            .database, api: "get_recent_transaction_by_id", returnType: ProcessedTransaction<Input>.self, params: [id]
        )
    }
}
