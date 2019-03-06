import Foundation

struct GetRequiredFees: BaseRequestConvertible {
    
    typealias Output = [AssetAmount]
    private(set) var base: BaseRequest<[AssetAmount]>
    
    init(_ operations: [Operation], assetId: ChainObject = DCore.Constant.dct) {
        
        precondition(assetId.objectType == .assetObject, "Not a valid asset object id")
        self.base = GetRequiredFees.toBase(
            .database, api: "get_required_fees", returnType: [AssetAmount].self, params: [
                operations.map { $0.asAnyOperation() }, assetId
            ]
        )
    }
}
