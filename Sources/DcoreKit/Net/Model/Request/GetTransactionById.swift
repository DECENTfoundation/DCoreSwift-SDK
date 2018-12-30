import Foundation

class GetTransactionById: BaseRequest<ProcessedTransaction> {
    
    required init(id: String) {
        guard id.count == 20 else { preconditionFailure("invalid transaction id") }
        super.init(.database, api: "get_transaction_by_id", returnClass: ProcessedTransaction.self, params: [id])
    }
}
