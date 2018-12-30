import Foundation

class SetPendingTransactionCallback: BaseRequest<UnitValue>, WithCallback {
 
    required init() {
        super.init(.database, api: "set_pending_transaction_callback", returnClass: UnitValue.self)
    }
}
