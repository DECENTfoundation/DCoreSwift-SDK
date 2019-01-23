import Foundation

struct GetTransactionById<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = ProcessedTransaction<Input>
    private(set) var base: BaseRequest<ProcessedTransaction<Input>>
    
    init(_ id: String) {
        
        precondition(id.unhex()?.count == 20, "Invalid transaction id")
        self.base = GetTransactionById.toBase(
            .database, api: "get_transaction_by_id", returnType: ProcessedTransaction<Input>.self, params: [id]
        )
    }
}
