import Foundation

struct SetBlockAppliedCallback: BaseRequestConvertible {
    
    typealias Output = String
    private(set) var base: BaseRequest<String>
    
    init() {
        self.base = SetBlockAppliedCallback.toBaseCallback(
            .database, api: "set_block_applied_callback", returnType: String.self
        )
    }
}
