import Foundation

class GetSeeder: BaseRequest<Seeder> {
    
    required init(accountId: ChainObject) {
        guard accountId.objectType == ObjectType.accountObject else { preconditionFailure("not a valid account object id") }
        super.init(.database, api: "get_seeder", returnClass: Seeder.self, params: [accountId])
    }
}
