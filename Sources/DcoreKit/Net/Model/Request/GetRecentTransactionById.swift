import Foundation

class GetRecentTransactionById: BaseRequest<ProcessedTransaction> {
    
    required init(id: String) {
        guard id.count == 20 else { preconditionFailure("invalid transaction id") }
        super.init(api: .DATABASE, method: "get_recent_transaction_by_id", returnClass: ProcessedTransaction.self, params: [id])
    }
}
