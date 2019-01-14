import Foundation

struct GenerateContentKeys: BaseRequestConvertible {
    
    typealias Output = ContentKeys
    private(set) var base: BaseRequest<ContentKeys>
    
    init(_ seeders: [ChainObject]) {
        
        precondition(seeders.allSatisfy { $0.objectType == .accountObject }, "Not a valid account object id")
        self.base = GenerateContentKeys.toBase(
            .database, api: "generate_content_keys", returnClass: ContentKeys.self, params: [seeders]
        )
    }
}
