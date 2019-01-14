import Foundation

struct GetAccountById: BaseRequestConvertible {
    
    typealias Output = [Account]
    private(set) var base: BaseRequest<[Account]>
    
    init(_ ids: [ChainObject]) {
        
        precondition(ids.allSatisfy { $0.objectType == .accountObject }, "Not a valid account object id")
        self.base = GetObjects(ids, returnClass: [Account].self).base
    }
}
