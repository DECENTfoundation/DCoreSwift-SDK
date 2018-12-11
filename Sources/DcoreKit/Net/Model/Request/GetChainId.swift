import Foundation

class GetChainId: BaseRequest<String> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_chain_id", returnClass: String.self)
    }
}
