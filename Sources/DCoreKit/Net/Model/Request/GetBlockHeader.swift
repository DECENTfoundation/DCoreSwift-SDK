import Foundation

struct GetBlockHeader: BaseRequestConvertible {
    
    typealias Output = BlockHeader
    private(set) var base: BaseRequest<BlockHeader>
    
    init(_ blockNum: UInt64) {
        self.base = GetBlockHeader.toBase(
            .database, api: "get_block_header", returnType: BlockHeader.self, params: [blockNum]
        )
    }
}
