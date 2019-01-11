import Foundation

struct GetRequiredFees: BaseRequestConvertible {
    
    typealias Output = [AssetAmount]
    private(set) var base: BaseRequest<[AssetAmount]>
    
    init(_ operations: [BaseOperation], assetId: ChainObject = DCore.Constant.Default.dct) {
        
        precondition(assetId.objectType == .assetObject, "Not a valid asset object id")
        self.base = GetRequiredFees.toBase(.database, api: "get_required_fees", returnClass: [AssetAmount].self, params: [
            operations.map({ RequiredFee($0) }), assetId
        ])
    }
}
