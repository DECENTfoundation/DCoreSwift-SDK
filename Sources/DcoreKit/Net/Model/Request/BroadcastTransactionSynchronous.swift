import Foundation

struct BroadcastTransactionSynchronous<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = TransactionConfirmation<Input>
    private(set) var base: BaseRequest<TransactionConfirmation<Input>>
    
    init(_ trx: Transaction<Input>) {
        
        precondition(!trx.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        self.base = BroadcastTransactionSynchronous.toBase(
            .broadcast,
            api: "broadcast_transaction_synchronous",
            returnType: TransactionConfirmation<Input>.self,
            params: [trx]
        )
    }
}
