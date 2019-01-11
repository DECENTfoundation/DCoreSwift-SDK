import Foundation

struct GetKeyReferences: BaseRequestConvertible {
    
    typealias Output = [[ChainObject]]
    private(set) var base: BaseRequest<[[ChainObject]]>
    
    init(_ references: [Address]) {
        self.base = GetKeyReferences.toBase(.database, api: "get_key_references", returnClass: [[ChainObject]].self, params: [references])
    }
}
