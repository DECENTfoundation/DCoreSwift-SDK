import Foundation
import BigInt

struct GetAssetPerBlock: BaseRequestConvertible {
    
    typealias Output = BigInt
    private(set) var base: BaseRequest<BigInt>
    
    init(_ blockNum: UInt64) {
        self.base = GetAssetPerBlock.toBase(
            .database, api: "get_asset_per_block_by_block_num", returnType: BigInt.self, params: [blockNum]
        )
    }
}
