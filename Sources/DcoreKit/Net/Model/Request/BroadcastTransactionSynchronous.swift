import Foundation

class BroadcastTransactionSynchronous: BaseRequest<TransactionConfirmation> {
    
    required init(transaction: Transaction) {
        guard !transaction.signatures!.isEmpty else { preconditionFailure("transaction not signed, forgot to call .withSignature(key) ?") }
        super.init(api: .BROADCAST, method: "broadcast_transaction_synchronous", returnClass: TransactionConfirmation.self, params: [transaction])
    }
}
