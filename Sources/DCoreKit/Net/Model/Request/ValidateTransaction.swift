import Foundation

struct ValidateTransaction: BaseRequestConvertible {
    
    typealias Output = ProcessedTransaction
    private(set) var base: BaseRequest<ProcessedTransaction>
    
    init(_ trx: Transaction) {
        self.base = ValidateTransaction.toBase(
            .database, api: "validate_transaction", returnType: ProcessedTransaction.self, params: [trx]
        )
    }
}
