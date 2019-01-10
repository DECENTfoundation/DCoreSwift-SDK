import Foundation

class GetSeeder: BaseRequest<Seeder> {
    
    required init(accountId: ChainObject) {
        
        precondition(accountId.objectType == .accountObject, "Not a valid account object id")
        super.init(.database, api: "get_seeder", returnClass: Seeder.self, params: [accountId])
    }
}
