import Foundation

struct GetAssetsData: BaseRequestConvertible {
    
    typealias Output = [AssetData]
    private(set) var base: BaseRequest<[AssetData]>
    
    init(_ ids: [AssetDataObjectId]) {
        self.base = GetObjects(ids, returnType: [AssetData].self).base
    }
}
