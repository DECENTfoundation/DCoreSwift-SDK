import Foundation

struct GetMiners: BaseRequestConvertible {
    
    typealias Output = [Miner]
    private(set) var base: BaseRequest<[Miner]>
    
    init(_ ids: [MinerObjectId]) {
        self.base = GetObjects(ids, returnType: [Miner].self).base
    }
}
