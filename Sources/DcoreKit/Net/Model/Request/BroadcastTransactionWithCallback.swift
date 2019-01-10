import Foundation

class BroadcastTransactionWithCallback: BaseRequest<TransactionConfirmation> {
    
    required init(transaction: Transaction) {
        
        precondition(!transaction.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        super.init(.broadcast, api: "broadcast_transaction_with_callback", returnClass: TransactionConfirmation.self, params: [transaction])
    }
}
