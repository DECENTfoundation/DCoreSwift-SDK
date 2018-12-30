import Foundation

class BroadcastTransactionWithCallback: BaseRequest<TransactionConfirmation> {
    
    required init(transaction: Transaction) {
        guard !transaction.signatures!.isEmpty else { preconditionFailure("transaction not signed, forgot to call .withSignature(key) ?") }
        super.init(.broadcast, api: "broadcast_transaction_with_callback", returnClass: TransactionConfirmation.self, params: [transaction])
    }
}
