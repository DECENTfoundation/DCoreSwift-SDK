import Foundation

class SetBlockAppliedCallback : BaseRequest<String>, WithCallback {
    
    required init() {
        super.init(api: .DATABASE, method: "set_block_applied_callback", returnClass: String.self)
    }
}
