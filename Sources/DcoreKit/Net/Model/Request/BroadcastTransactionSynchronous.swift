import Foundation

struct BroadcastTransactionSynchronous: BaseRequestConvertible {
    
    typealias Output = TransactionConfirmation
    private(set) var base: BaseRequest<TransactionConfirmation>
    
    init(_ trx: Transaction) {
        
        precondition(!trx.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        self.base = BroadcastTransactionSynchronous.toBase(
            .broadcast,
            api: "broadcast_transaction_synchronous",
            returnClass: TransactionConfirmation.self,
            params: [trx]
        )
    }
}
