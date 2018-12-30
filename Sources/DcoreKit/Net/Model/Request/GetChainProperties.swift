import Foundation

class GetChainProperties: BaseRequest<ChainProperty> {
    
    required init() {
        super.init(.database, api: "get_chain_properties", returnClass: ChainProperty.self)
    }
}
