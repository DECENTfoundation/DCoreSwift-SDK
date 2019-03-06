import Foundation

struct GetTransaction: BaseRequestConvertible {
    
    typealias Output = ProcessedTransaction
    private(set) var base: BaseRequest<ProcessedTransaction>
    
    init(_ blockNum: UInt64, trxInBlock: UInt64) {
        self.base = GetTransaction.toBase(
            .database,
            api: "get_transaction",
            returnType: ProcessedTransaction.self,
            params: [blockNum, trxInBlock]
        )
    }
}
