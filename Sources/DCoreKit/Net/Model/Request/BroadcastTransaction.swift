import Foundation

struct BroadcastTransaction: BaseRequestConvertible {
    
    typealias Output = UnitValue
    private(set) var base: BaseRequest<UnitValue>
    
    init<Input>(_ trx: Transaction<Input>) where Input: Operation {
        
        precondition(!trx.signatures!.isEmpty, "Transaction not signed, forgot to call .withSignature(key) ?")
        self.base = BroadcastTransaction.toBase(
            .broadcast, api: "broadcast_transaction", returnType: UnitValue.self, params: [trx]
        )
    }
}
