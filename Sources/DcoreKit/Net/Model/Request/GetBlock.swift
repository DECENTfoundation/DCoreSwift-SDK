import Foundation


class GetBlock: BaseRequest<SignedBlock> {
    
    required init(blockNum: UInt64) {
        super.init(api: .DATABASE, method: "get_block", returnClass: SignedBlock.self, params: [blockNum])
    }
}
