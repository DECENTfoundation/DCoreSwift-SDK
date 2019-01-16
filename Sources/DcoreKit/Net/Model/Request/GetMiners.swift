import Foundation

struct GetMiners: BaseRequestConvertible {
    
    typealias Output = [Miner]
    private(set) var base: BaseRequest<[Miner]>
    
    init(_ ids: [ChainObject]) {
        
        precondition(ids.allSatisfy { $0.objectType  == .minerObject }, "Not a valid miner object id")
        self.base = GetObjects(ids, returnType: [Miner].self).base
    }
}
