import Foundation

class GetSeeder: BaseRequest<Seeder> {
    
    required init(accountId: ChainObject) {
        guard accountId.objectType == ObjectType.ACCOUNT_OBJECT else { preconditionFailure("not a valid account object id") }
        super.init(api: .DATABASE, method: "get_seeder", returnClass: Seeder.self, params: [accountId])
    }
}
