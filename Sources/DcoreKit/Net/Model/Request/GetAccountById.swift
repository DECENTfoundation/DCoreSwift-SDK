import Foundation

class GetAccountById: GetObjects<[Account]> {
    
    required init(_ ids: [ChainObject]) {
        
        precondition(ids.allSatisfy{ $0.objectType == .accountObject },"Not a valid account object id")
        super.init(objects: ids, returnClass: [Account].self)
    }
}
