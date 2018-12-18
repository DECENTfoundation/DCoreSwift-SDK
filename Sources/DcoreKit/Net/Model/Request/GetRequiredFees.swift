import Foundation

class GetRequiredFees: BaseRequest<[AssetAmount]> {
    
    required init(operations: [BaseOperation], assetId: ChainObject = DCore.Constants.Defaults.DCT_ASSET_ID) {
        guard assetId.objectType == ObjectType.ASSET_OBJECT else { preconditionFailure("not a valid asset object id") }
        super.init(api: .DATABASE, method: "get_required_fees", returnClass: [AssetAmount].self, params: [
            operations.map({ [$0.type, $0] }), assetId
        ])
    }
}
