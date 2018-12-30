import Foundation

class GetAccountById: GetObjects<[Account]> {
    
    required init(_ ids: [ChainObject]) {
        guard ids.allSatisfy({ $0.objectType == ObjectType.accountObject }) else { preconditionFailure("Not a valid account object id") }
        super.init(objects: ids, returnClass: [Account].self)
    }
}
