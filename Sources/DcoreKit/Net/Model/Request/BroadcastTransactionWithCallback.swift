import Foundation

struct BroadcastTransactionWithCallback: BaseRequestConvertible {
    
    typealias Output = TransactionConfirmation
    private(set) var base: BaseRequest<TransactionConfirmation>
    
    init(_ trx: Transaction) {
        
        precondition(!trx.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        self.base = BroadcastTransactionWithCallback.toBaseCallback(.broadcast,
            api: "broadcast_transaction_with_callback",
            returnClass: TransactionConfirmation.self,
            params: [trx]
        )
    }
}
