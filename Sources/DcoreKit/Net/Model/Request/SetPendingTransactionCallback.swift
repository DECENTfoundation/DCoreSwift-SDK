import Foundation

struct SetPendingTransactionCallback: BaseRequestConvertible {
    
    typealias Output = UnitValue
    private(set) var base: BaseRequest<UnitValue>
    
    init() {
        self.base = SetPendingTransactionCallback.toBaseCallback(
            .database, api: "set_pending_transaction_callback", returnClass: UnitValue.self
        )
    }
}
