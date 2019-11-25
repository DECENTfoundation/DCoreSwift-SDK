import Foundation

struct GetKeyReferences: BaseRequestConvertible {
    
    typealias Output = [[AccountObjectId]]
    private(set) var base: BaseRequest<[[AccountObjectId]]>
    
    init(_ references: [Address]) {
        self.base = GetKeyReferences.toBase(
            .database, api: "get_key_references", returnType: [[AccountObjectId]].self, params: [references]
        )
    }
}
