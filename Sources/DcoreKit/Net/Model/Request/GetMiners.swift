import Foundation

class GetMiners: GetObjects<[Miner]> {
    
    required init(minerIds: [ChainObject]) {
        
        precondition(minerIds.allSatisfy{ $0.objectType  == .minerObject }, "Not a valid miner object id")
        super.init(objects: minerIds, returnClass: [Miner].self)
    }
}
