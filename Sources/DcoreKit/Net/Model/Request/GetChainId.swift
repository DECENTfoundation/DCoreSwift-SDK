import Foundation

class GetChainId: BaseRequest<String> {
    
    required init() {
        super.init(.database, api: "get_chain_id", returnClass: String.self)
    }
}
