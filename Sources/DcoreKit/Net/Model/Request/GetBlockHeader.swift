import Foundation

class GetBlockHeader: BaseRequest<BlockHeader> {
    
    required init(blockNum: UInt64) {
        super.init(.database, api: "get_block_header", returnClass: BlockHeader.self, params: [blockNum])
    }
}
