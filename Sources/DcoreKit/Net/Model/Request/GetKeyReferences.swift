import Foundation


class GetKeyReferences: BaseRequest<[[ChainObject]]> {
    
    required init(_ references: [Address]) {
        super.init(.database, api: "get_key_references", returnClass: [[ChainObject]].self, params: [references])
    }
}
