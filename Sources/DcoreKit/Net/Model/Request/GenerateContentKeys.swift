import Foundation

class GenerateContentKeys: BaseRequest<ContentKeys> {
    
    required init(seeders: [ChainObject]) {
        guard seeders.allSatisfy({ $0.objectType == ObjectType.accountObject }) else { preconditionFailure("not a valid account object id") }
        super.init(.database, api: "generate_content_keys", returnClass: ContentKeys.self, params: [seeders])
    }
}

