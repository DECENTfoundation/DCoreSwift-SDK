import Foundation

struct GetChainProperties: BaseRequestConvertible {
    
    typealias Output = ChainProperty
    private(set) var base: BaseRequest<ChainProperty>
    
    init() {
        self.base = GetChainProperties.toBase(.database, api: "get_chain_properties", returnClass: ChainProperty.self)
    }
}
