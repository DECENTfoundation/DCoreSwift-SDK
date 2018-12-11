import Foundation


class GetKeyReferences: BaseRequest<[[ChainObject]]> {
    
    required init(address: [Address]) {
        super.init(api: .DATABASE, method: "get_key_references", returnClass: [[ChainObject]].self, params: [address])
    }
}
