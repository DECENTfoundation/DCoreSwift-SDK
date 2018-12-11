import Foundation
import BigInt

class GetAssetPerBlock: BaseRequest<BigInt> {
    
    required init(blockNum: UInt64) {
        super.init(api: .DATABASE, method: "get_asset_per_block_by_block_num", returnClass: BigInt.self, params: [blockNum])
    }
}
