import Foundation
import BigInt

class GetNewAssetPerBlock : BaseRequest<BigInt> {
    
    required init() {
        super.init(api: .DATABASE, method: "get_new_asset_per_block", returnClass: BigInt.self)
    }
}
