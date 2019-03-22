import Foundation

struct GetChainProperties: BaseRequestConvertible {
    
    typealias Output = ChainProperties
    private(set) var base: BaseRequest<ChainProperties>
    
    init() {
        self.base = GetChainProperties.toBase(.database, api: "get_chain_properties", returnType: ChainProperties.self)
    }
}
