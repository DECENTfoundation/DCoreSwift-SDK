import Foundation

struct GetBlock: BaseRequestConvertible {
    
    typealias Output = SignedBlock
    private(set) var base: BaseRequest<SignedBlock>
    
    init(_ blockNum: UInt64) {
        self.base = GetBlock.toBase(.database, api: "get_block", returnType: SignedBlock.self, params: [blockNum])
    }
}
