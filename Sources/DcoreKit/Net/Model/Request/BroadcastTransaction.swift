import Foundation

class BroadcastTransaction: BaseRequest<Void> {
    
    required init(transaction: Transaction) {
        guard !transaction.signatures!.isEmpty else { preconditionFailure("transaction not signed, forgot to call .withSignature(key) ?") }
        super.init(api: .BROADCAST, method: "broadcast_transaction", returnClass: Void.self, params: [transaction])
    }
}
