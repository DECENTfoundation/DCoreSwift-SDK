import Foundation

class ValidateTransaction: BaseRequest<ProcessedTransaction> {
    
    required init(transaction: Transaction) {
        super.init(.database, api: "validate_transaction", returnClass: ProcessedTransaction.self, params: [transaction])
    }
}
