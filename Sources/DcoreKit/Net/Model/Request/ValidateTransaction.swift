import Foundation

class ValidateTransaction: BaseRequest<ProcessedTransaction> {
    
    required init(transaction: Transaction) {
        super.init(api: .DATABASE, method: "validate_transaction", returnClass: ProcessedTransaction.self, params: [transaction])
    }
}
