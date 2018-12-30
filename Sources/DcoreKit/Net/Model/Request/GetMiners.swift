import Foundation

class GetMiners: GetObjects<[Miner]> {
    
    required init(minerIds: [ChainObject]) {
        guard minerIds.allSatisfy({ $0.objectType  == ObjectType.minerObject }) else { preconditionFailure("not a valid miner object id") }
        super.init(objects: minerIds, returnClass: [Miner].self)
    }
}
