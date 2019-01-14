import Foundation

struct BroadcastTransaction: BaseRequestConvertible {
    
    typealias Output = UnitValue
    private(set) var base: BaseRequest<UnitValue>
    
    init(_ trx: Transaction) {
        
        precondition(!trx.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        self.base = BroadcastTransaction.toBase(
            .broadcast, api: "broadcast_transaction", returnClass: UnitValue.self, params: [trx]
        )
    }
}
