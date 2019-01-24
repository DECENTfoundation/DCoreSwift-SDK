import Foundation

struct GetBlock<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = SignedBlock<Input>
    private(set) var base: BaseRequest<SignedBlock<Input>>
    
    init(_ blockNum: UInt64) {
        self.base = GetBlock.toBase(.database, api: "get_block", returnType: SignedBlock<Input>.self, params: [blockNum])
    }
}
