import Foundation

struct GetAssetsData: BaseRequestConvertible {
    
    typealias Output = [AssetData]
    private(set) var base: BaseRequest<[AssetData]>
    
    init(_ ids: [ChainObject]) {
        
        precondition(ids.allSatisfy { $0.objectType == .assetDynamicData }, "Not a valid asset data object id")
        self.base = GetObjects(ids, returnType: [AssetData].self).base
    }
}
