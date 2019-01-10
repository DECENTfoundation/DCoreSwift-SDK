import Foundation

class GetTransactionById: BaseRequest<ProcessedTransaction> {
    
    required init(id: String) {
        
        precondition(id.unhex()?.count == 20, "Invalid transaction id")
        super.init(.database, api: "get_transaction_by_id", returnClass: ProcessedTransaction.self, params: [id])
    }
}
