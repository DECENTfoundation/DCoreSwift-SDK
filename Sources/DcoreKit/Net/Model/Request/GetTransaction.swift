import Foundation

class GetTransaction: BaseRequest<ProcessedTransaction> {
 
    required init(blockNum: UInt64, trxInBlock: UInt64) {
        super.init(api: .DATABASE, method: "get_transaction", returnClass: ProcessedTransaction.self, params: [blockNum, trxInBlock])
    }
}
