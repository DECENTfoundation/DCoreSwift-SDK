import Foundation

struct GetChainId: BaseRequestConvertible {
    
    typealias Output = String
    private(set) var base: BaseRequest<String>
    
    init() {
        self.base = GetChainId.toBase(.database, api: "get_chain_id", returnType: String.self)
    }
}
