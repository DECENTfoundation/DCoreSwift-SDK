import Foundation

class SetPendingTransactionCallback: BaseRequest<Void>, WithCallback {
 
    required init() {
        super.init(api: .DATABASE, method: "set_pending_transaction_callback", returnClass: Void.self)
    }
}
