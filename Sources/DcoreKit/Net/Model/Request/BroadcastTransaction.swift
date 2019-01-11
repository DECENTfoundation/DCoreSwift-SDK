import Foundation



final class BroadcastTransaction: BaseRequest<UnitValue> {
    
    required init(transaction: Transaction) {
        
        precondition(!transaction.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        super.init(.broadcast, api: "broadcast_transaction", returnClass: UnitValue.self, params: [transaction])
    }
}
