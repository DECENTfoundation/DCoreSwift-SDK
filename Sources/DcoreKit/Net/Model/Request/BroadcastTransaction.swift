import Foundation

class BroadcastTransaction: BaseRequest<UnitValue> {
    
    required init(transaction: Transaction) {
        guard !transaction.signatures!.isEmpty else { preconditionFailure("Transaction not signed, forgot to call .withSignature(key) ?") }
        super.init(.broadcast, api: "broadcast_transaction", returnClass: UnitValue.self, params: [transaction])
    }
}
