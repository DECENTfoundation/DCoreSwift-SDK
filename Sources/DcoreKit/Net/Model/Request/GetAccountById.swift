import Foundation

class GetAccountById: GetObjects<[Account]> {
    
    required init(accountIds: [ChainObject]) {
        guard accountIds.allSatisfy({ $0.objectType == ObjectType.ACCOUNT_OBJECT }) else { preconditionFailure("not a valid account object id") }
        super.init(objects: accountIds, returnClass: [Account].self)
    }
}
