import Foundation

struct BroadcastTransactionWithCallback<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = TransactionConfirmation<Input>
    private(set) var base: BaseRequest<TransactionConfirmation<Input>>
    
    init(_ trx: Transaction<Input>) {
        
        precondition(!trx.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        self.base = BroadcastTransactionWithCallback.toBaseCallback(.broadcast,
            api: "broadcast_transaction_with_callback",
            returnType: TransactionConfirmation<Input>.self,
            params: [trx]
        )
    }
}
