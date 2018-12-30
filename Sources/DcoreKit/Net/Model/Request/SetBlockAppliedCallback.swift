import Foundation

class SetBlockAppliedCallback : BaseRequest<String>, WithCallback {
    
    required init() {
        super.init(.database, api: "set_block_applied_callback", returnClass: String.self)
    }
}
