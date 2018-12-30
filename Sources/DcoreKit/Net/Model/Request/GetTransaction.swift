import Foundation

class GetTransaction: BaseRequest<ProcessedTransaction> {
 
    required init(blockNum: UInt64, trxInBlock: UInt64) {
        super.init(.database, api: "get_transaction", returnClass: ProcessedTransaction.self, params: [blockNum, trxInBlock])
    }
}
