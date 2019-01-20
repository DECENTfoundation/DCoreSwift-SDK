import Foundation

struct GetTransaction<Input>: BaseRequestConvertible where Input: Operation {
    
    typealias Output = ProcessedTransaction<Input>
    private(set) var base: BaseRequest<ProcessedTransaction<Input>>
    
    init(_ blockNum: UInt64, trxInBlock: UInt64) {
        self.base = GetTransaction.toBase(
            .database,
            api: "get_transaction",
            returnType: ProcessedTransaction<Input>.self,
            params: [blockNum, trxInBlock]
        )
    }
}
