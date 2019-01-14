import Foundation
import BigInt

struct GetNewAssetPerBlock: BaseRequestConvertible {
    
    typealias Output = BigInt
    private(set) var base: BaseRequest<BigInt>
    
    init() {
        self.base = GetNewAssetPerBlock.toBase(.database, api: "get_new_asset_per_block", returnClass: BigInt.self)
    }
}
