import Foundation

class GenerateContentKeys: BaseRequest<ContentKeys> {
    
    required init(seeders: [ChainObject]) {
        guard seeders.allSatisfy({ $0.objectType == ObjectType.ACCOUNT_OBJECT }) else { preconditionFailure("not a valid account object id") }
        super.init(api: .DATABASE, method: "generate_content_keys", returnClass: ContentKeys.self, params: [seeders])
    }
}

