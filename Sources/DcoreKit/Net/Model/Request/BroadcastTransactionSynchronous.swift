import Foundation

class BroadcastTransactionSynchronous: BaseRequest<TransactionConfirmation> {
    
    required init(transaction: Transaction) {
        guard !transaction.signatures!.isEmpty else { preconditionFailure("Transaction not signed, forgot to call .withSignature(key) ?") }
        super.init(.broadcast, api: "broadcast_transaction_synchronous", returnClass: TransactionConfirmation.self, params: [transaction])
    }
}
