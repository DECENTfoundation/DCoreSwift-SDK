import Foundation

final class GenerateContentKeys: BaseRequest<ContentKeys> {
    
    required init(seeders: [ChainObject]) {
        
        precondition(seeders.allSatisfy{ $0.objectType == .accountObject }, "Not a valid account object id")
        super.init(.database, api: "generate_content_keys", returnClass: ContentKeys.self, params: [seeders])
    }
}

