import Foundation


class GetKeyReferences: BaseRequest<[[ChainObject]]> {
    
    required init(addresses: [Address]) {
        super.init(api: .DATABASE, method: "get_key_references", returnClass: [[ChainObject]].self, params: [addresses])
    }
}
