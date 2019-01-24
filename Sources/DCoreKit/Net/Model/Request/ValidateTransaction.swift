import Foundation

struct ValidateTransaction<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = ProcessedTransaction<Input>
    private(set) var base: BaseRequest<ProcessedTransaction<Input>>
    
    init(_ trx: Transaction<Input>) {
        self.base = ValidateTransaction.toBase(
            .database, api: "validate_transaction", returnType: ProcessedTransaction<Input>.self, params: [trx]
        )
    }
}
