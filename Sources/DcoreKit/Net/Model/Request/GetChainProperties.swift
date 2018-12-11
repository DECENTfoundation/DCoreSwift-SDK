import Foundation

class GetChainProperties: BaseRequest<ChainProperty> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_chain_properties", returnClass: ChainProperty.self)
    }
}
